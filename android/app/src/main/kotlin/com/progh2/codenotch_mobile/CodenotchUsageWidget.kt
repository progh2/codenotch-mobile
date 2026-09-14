package com.progh2.codenotch_mobile

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.RectF
import android.os.Build
import android.util.TypedValue
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider
import kotlin.math.max
import kotlin.math.min

/// Home-screen App Widget: mint horseshoe ring + mock percent + short label.
///
/// Reads [home_widget] SharedPreferences. Tap cycles the mock catalog.
/// Live usage APIs are out of scope.
class CodenotchUsageWidget : HomeWidgetProvider() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == ACTION_REFRESH) {
            val prefs = HomeWidgetPlugin.getData(context)
            cycleMock(prefs)
            val manager = AppWidgetManager.getInstance(context)
            val ids =
                manager.getAppWidgetIds(
                    ComponentName(context, CodenotchUsageWidget::class.java),
                )
            onUpdate(context, manager, ids)
            return
        }
        super.onReceive(context, intent)
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val snapshot = readSnapshot(widgetData)
        if (widgetData.getString(KEY_USAGE, null).isNullOrBlank()) {
            writeSnapshot(widgetData, snapshot, widgetData.getInt(KEY_INDEX, 0))
        }

        val density = context.resources.displayMetrics.density

        appWidgetIds.forEach { widgetId ->
            val options = appWidgetManager.getAppWidgetOptions(widgetId)
            val minWidthDp =
                options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 110)
                    .coerceAtLeast(80)
            val minHeightDp =
                options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 110)
                    .coerceAtLeast(80)
            val shortSideDp = min(minWidthDp, minHeightDp)
            val ringSize = (shortSideDp * density).toInt().coerceIn(200, 640)
            val ring = drawUsageRing(ringSize, snapshot.percent, density)
            val percentDp = minHeightDp * PERCENT_HEIGHT_RATIO
            val labelDp = percentDp * LABEL_TO_PERCENT_RATIO

            val views =
                RemoteViews(context.packageName, R.layout.codenotch_usage_widget).apply {
                    setImageViewBitmap(R.id.widget_ring, ring)
                    setTextViewText(R.id.widget_usage, snapshot.percentText)
                    setTextViewText(R.id.widget_label, snapshot.label)
                    setTextViewTextSize(
                        R.id.widget_usage,
                        TypedValue.COMPLEX_UNIT_DIP,
                        percentDp,
                    )
                    setTextViewTextSize(
                        R.id.widget_label,
                        TypedValue.COMPLEX_UNIT_DIP,
                        labelDp,
                    )
                    setOnClickPendingIntent(
                        R.id.widget_root,
                        refreshIntent(context, widgetId),
                    )
                }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun refreshIntent(context: Context, widgetId: Int): PendingIntent {
        val intent =
            Intent(context, CodenotchUsageWidget::class.java).apply {
                action = ACTION_REFRESH
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
            }
        val flags =
            PendingIntent.FLAG_UPDATE_CURRENT or
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    PendingIntent.FLAG_IMMUTABLE
                } else {
                    0
                }
        return PendingIntent.getBroadcast(context, widgetId, intent, flags)
    }

    companion object {
        const val ACTION_REFRESH = "com.progh2.codenotch_mobile.ACTION_REFRESH_MOCK"
        const val KEY_USAGE = "usage"
        const val KEY_LABEL = "label"
        const val KEY_PERCENT = "percent"
        const val KEY_INDEX = "mock_index"

        private val MOCKS =
            listOf(
                MockSnapshot(72, "Mock usage"),
                MockSnapshot(41, "Sample quota"),
                MockSnapshot(88, "Demo ring"),
            )

        private const val COLOR_TRACK = 0xFF1C2430.toInt()
        private const val COLOR_FILL = 0xFF5EEAD4.toInt()
        private const val COLOR_PERCENT = 0xFFF3F6FA.toInt()
        private const val START_DEGREES = 135f
        private const val SWEEP_DEGREES = 270f
        private const val HIGHLIGHT_START = 210f
        private const val HIGHLIGHT_SWEEP = 120f
        private const val HIGHLIGHT_MIX = 0.25f
        private const val INNER_PADDING_RATIO = 0.12f
        private const val PERCENT_HEIGHT_RATIO = 0.28f
        private const val LABEL_TO_PERCENT_RATIO = 0.40f
        private const val STROKE_DP = 6f

        internal fun readSnapshot(prefs: SharedPreferences): MockSnapshot {
            val usage = prefs.getString(KEY_USAGE, null)
            val label = prefs.getString(KEY_LABEL, null)
            val storedPercent = prefs.getInt(KEY_PERCENT, -1)
            val percent =
                when {
                    storedPercent in 0..100 -> storedPercent
                    usage != null -> usage.trimEnd('%').toIntOrNull() ?: MOCKS.first().percent
                    else -> MOCKS.first().percent
                }
            return MockSnapshot(
                percent = percent,
                label = if (label.isNullOrBlank()) MOCKS.first().label else label,
            )
        }

        internal fun cycleMock(prefs: SharedPreferences) {
            val next = (prefs.getInt(KEY_INDEX, 0) + 1) % MOCKS.size
            writeSnapshot(prefs, MOCKS[next], next)
        }

        internal fun writeSnapshot(
            prefs: SharedPreferences,
            snapshot: MockSnapshot,
            index: Int,
        ) {
            prefs.edit()
                .putString(KEY_USAGE, snapshot.percentText)
                .putString(KEY_LABEL, snapshot.label)
                .putInt(KEY_PERCENT, snapshot.percent)
                .putInt(KEY_INDEX, index)
                .apply()
        }

        internal fun highlightSweep(progress: Float): Pair<Float, Float>? {
            val fillEnd = START_DEGREES + SWEEP_DEGREES * progress.coerceIn(0f, 1f)
            val overlapStart = max(START_DEGREES, HIGHLIGHT_START)
            val overlapEnd = min(fillEnd, HIGHLIGHT_START + HIGHLIGHT_SWEEP)
            if (overlapEnd <= overlapStart) return null
            return overlapStart to (overlapEnd - overlapStart)
        }

        internal fun drawUsageRing(size: Int, percent: Int, density: Float): Bitmap {
            val bitmap = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            val stroke = STROKE_DP * density
            val pad = size * INNER_PADDING_RATIO
            val rect = RectF(pad, pad, size - pad, size - pad)
            val clamped = min(100, maxOf(0, percent)) / 100f
            val highlightColor = lerpColor(COLOR_FILL, COLOR_PERCENT, HIGHLIGHT_MIX)

            val track =
                Paint(Paint.ANTI_ALIAS_FLAG).apply {
                    style = Paint.Style.STROKE
                    strokeWidth = stroke
                    strokeCap = Paint.Cap.ROUND
                    color = COLOR_TRACK
                }
            val fill =
                Paint(Paint.ANTI_ALIAS_FLAG).apply {
                    style = Paint.Style.STROKE
                    strokeWidth = stroke
                    strokeCap = Paint.Cap.ROUND
                    color = COLOR_FILL
                }
            val highlight =
                Paint(Paint.ANTI_ALIAS_FLAG).apply {
                    style = Paint.Style.STROKE
                    strokeWidth = stroke
                    strokeCap = Paint.Cap.ROUND
                    color = highlightColor
                }

            canvas.drawArc(rect, START_DEGREES, SWEEP_DEGREES, false, track)
            if (clamped > 0f) {
                canvas.drawArc(rect, START_DEGREES, SWEEP_DEGREES * clamped, false, fill)
                highlightSweep(clamped)?.let { (start, sweep) ->
                    canvas.drawArc(rect, start, sweep, false, highlight)
                }
            }
            return bitmap
        }

        private fun lerpColor(from: Int, to: Int, t: Float): Int {
            val r = Color.red(from) + ((Color.red(to) - Color.red(from)) * t).toInt()
            val g = Color.green(from) + ((Color.green(to) - Color.green(from)) * t).toInt()
            val b = Color.blue(from) + ((Color.blue(to) - Color.blue(from)) * t).toInt()
            return Color.argb(255, r, g, b)
        }
    }
}

internal data class MockSnapshot(
    val percent: Int,
    val label: String,
) {
    val percentText: String get() = "$percent%"
}

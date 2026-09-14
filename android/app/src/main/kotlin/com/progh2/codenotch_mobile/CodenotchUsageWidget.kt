package com.progh2.codenotch_mobile

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.RectF
import android.os.Build
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider
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
        val ringSize = (160 * density).toInt().coerceIn(200, 512)
        val ring = drawUsageRing(ringSize, snapshot.percent)

        appWidgetIds.forEach { widgetId ->
            val views =
                RemoteViews(context.packageName, R.layout.codenotch_usage_widget).apply {
                    setImageViewBitmap(R.id.widget_ring, ring)
                    setTextViewText(R.id.widget_usage, snapshot.percentText)
                    setTextViewText(R.id.widget_label, snapshot.label)
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
        private const val START_DEGREES = 135f
        private const val SWEEP_DEGREES = 270f

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

        internal fun drawUsageRing(size: Int, percent: Int): Bitmap {
            val bitmap = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            val stroke = size * 0.07f
            val pad = stroke * 1.15f / 2f + size * 0.03f
            val rect = RectF(pad, pad, size - pad, size - pad)
            val clamped = min(100, maxOf(0, percent)) / 100f

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
                    strokeWidth = stroke * 1.15f
                    strokeCap = Paint.Cap.ROUND
                    color = COLOR_FILL
                }

            canvas.drawArc(rect, START_DEGREES, SWEEP_DEGREES, false, track)
            if (clamped > 0f) {
                canvas.drawArc(rect, START_DEGREES, SWEEP_DEGREES * clamped, false, fill)
            }
            return bitmap
        }
    }
}

internal data class MockSnapshot(
    val percent: Int,
    val label: String,
) {
    val percentText: String get() = "$percent%"
}

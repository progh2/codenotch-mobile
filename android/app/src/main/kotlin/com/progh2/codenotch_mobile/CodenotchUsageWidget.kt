package com.progh2.codenotch_mobile

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

/// Empty-shell Android App Widget. Reads placeholder title/usage from
/// [home_widget] SharedPreferences. Live usage APIs are out of scope for M0.
class CodenotchUsageWidget : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views =
                RemoteViews(context.packageName, R.layout.codenotch_usage_widget).apply {
                    setTextViewText(
                        R.id.widget_title,
                        widgetData.getString("title", null) ?: "Codenotch",
                    )
                    setTextViewText(
                        R.id.widget_usage,
                        widgetData.getString("usage", null) ?: "--%",
                    )
                }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

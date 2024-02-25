package com.datsol.csrs

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import es.antonborri.home_widget.HomeWidgetProvider
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent

class SOSWidget : HomeWidgetProvider() {



    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {

    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach {widgetId ->
            val views = RemoteViews(context.packageName, R.layout.s_o_s_widget).apply {

                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)

                // Detect App opened via Click inside Flutter
                val pendingIntentWithData = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("sosWidget://titleClicked"))
                setOnClickPendingIntent(R.id.widget_container, pendingIntentWithData)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}
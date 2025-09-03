package sn.smapp.mobmovizz.widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import sn.smapp.mobmovizz.R
import sn.smapp.mobmovizz.widget.UpcomingWidgetStorage

class UpcomingWidgetProvider : AppWidgetProvider() {
    
    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        // Widget is enabled for the first time, force update
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val thisWidget = ComponentName(context, UpcomingWidgetProvider::class.java)
        val allWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
        onUpdate(context, appWidgetManager, allWidgetIds)
    }
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_upcoming)
            views.setTextViewText(R.id.widget_title, "Upcoming Movies")
            
            val upcomingJson = UpcomingWidgetStorage.getUpcoming(context)
            if (upcomingJson != null && upcomingJson.isNotEmpty()) {
                // Debug: log the JSON content
                android.util.Log.d("UpcomingWidget", "JSON data: $upcomingJson")
                
                // Parse and display movie titles with better formatting
                val titles = try {
                    val regex = "\"title\":\\s*\"([^\"]+)\"".toRegex()
                    val matches = regex.findAll(upcomingJson)
                    val movieTitles = matches.map { "• ${it.groupValues[1]}" }.take(8).toList()
                    if (movieTitles.isNotEmpty()) {
                        movieTitles.joinToString("\n")
                    } else {
                        "No movies found in data"
                    }
                } catch (e: Exception) {
                    android.util.Log.e("UpcomingWidget", "Error parsing JSON", e)
                    "Error loading movies: ${e.message}"
                }
                views.setTextViewText(R.id.widget_content, titles)
            } else {
                android.util.Log.d("UpcomingWidget", "No JSON data found")
                views.setTextViewText(R.id.widget_content, "No upcoming movies\nOpen app to load data")
            }

            // Action to open the app
            val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            if (intent != null) {
                val pendingIntent = PendingIntent.getActivity(
                    context, 
                    appWidgetId, 
                    intent, 
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                views.setOnClickPendingIntent(R.id.widget_content, pendingIntent)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}

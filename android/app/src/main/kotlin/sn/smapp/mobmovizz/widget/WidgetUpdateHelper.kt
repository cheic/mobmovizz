package sn.smapp.mobmovizz.widget

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context

object WidgetUpdateHelper {
    fun updateUpcomingWidget(context: Context) {
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val widgetComponent = ComponentName(context, UpcomingWidgetProvider::class.java)
        val ids = appWidgetManager.getAppWidgetIds(widgetComponent)
        if (ids.isNotEmpty()) {
            UpcomingWidgetProvider().onUpdate(context, appWidgetManager, ids)
        }
    }
}

package sn.smapp.mobmovizz.widget

import android.content.Context
import android.content.SharedPreferences

object UpcomingWidgetStorage {
    private const val PREFS_NAME = "FlutterSharedPreferences"
    private const val UPCOMING_KEY = "flutter.upcoming_movies"

    fun saveUpcoming(context: Context, data: String) {
        val prefs: SharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit().putString(UPCOMING_KEY, data).apply()
        android.util.Log.d("UpcomingWidget", "Saved data: ${data.take(100)}...")
    }

    fun getUpcoming(context: Context): String? {
        val prefs: SharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val data = prefs.getString(UPCOMING_KEY, null)
        android.util.Log.d("UpcomingWidget", "Retrieved data: ${data?.take(100) ?: "null"}")
        return data
    }
}

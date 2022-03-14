package com.example.cinepul.cinepulapp.service;

import android.content.Context;
import android.content.SharedPreferences;
import com.example.cinepul.cinepulapp.R;

public class SessionManager {

    private SharedPreferences prefs;
    final String USER_TOKEN = "user_token";

    public SessionManager(Context context) {
        prefs = context.getSharedPreferences(context.getString(R.string.app_name), Context.MODE_PRIVATE);
    }
    /**
     *on sauve le token
     */
    public void saveAuthToken(String token) {
        SharedPreferences.Editor editor = prefs.edit();
        editor.putString(USER_TOKEN, token);
        editor.apply();
    }
    /**
     * Fon récupère le token
     */
   public  String fetchAuthToken() {
        return prefs.getString(USER_TOKEN, null);
    }
}


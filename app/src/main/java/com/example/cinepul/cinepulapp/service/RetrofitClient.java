package com.example.cinepul.cinepulapp.service;

import android.content.Context;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.io.IOException;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import okhttp3.logging.HttpLoggingInterceptor;

public class RetrofitClient {
    private static Retrofit retrofit = null;
    private static HttpLoggingInterceptor intercepteur  = new  HttpLoggingInterceptor()
                 .setLevel(HttpLoggingInterceptor.Level.BASIC);

    public static Retrofit getClientRetrofit(Context c) {
        SessionManager uneSession  = new SessionManager(c);
        String unToken =uneSession.fetchAuthToken();
        if (retrofit == null) {
            OkHttpClient httpClient = new OkHttpClient.Builder()
                    .addInterceptor(new Interceptor() {
                        @Override
                        public Response intercept(Interceptor.Chain chain) throws IOException {
                            Request newRequest = chain.request().newBuilder()
                                    .build();
                            return chain.proceed(newRequest);
                        }
                    } )
                    .build();
            // on définit l'entête de l'appel
            Gson gson = new GsonBuilder()
                    .setDateFormat("yyyy-MM-dd'T'HH:mm:ss")
                    .setLenient()
                    .create();
              retrofit = new Retrofit.Builder()
                    .client(httpClient)
                    .baseUrl(AppelEntete.ENDPOINT)
                    .addConverterFactory(GsonConverterFactory.create(gson))
                    .build();
        }
        return retrofit;
    }
}


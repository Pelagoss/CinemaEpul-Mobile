package com.example.cinepul.cinepulapp.service;

/**
 * Created by christian on 06/11/2017.
 */

import com.example.cinepul.cinepulapp.domain.LoginParam;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.POST;

public interface ServiceConnexion
{
    // requête de contrôle
    @POST("authentification/login")
    Call<Object>    getConnexion(@Body LoginParam unL);

}
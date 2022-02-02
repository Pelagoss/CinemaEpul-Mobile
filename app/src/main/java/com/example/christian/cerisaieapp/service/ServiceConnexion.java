package com.example.christian.cerisaieapp.service;

/**
 * Created by christian on 06/11/2017.
 */

import com.example.christian.cerisaieapp.domain.LoginParam;
import com.example.christian.cerisaieapp.domain.Utilisateur;

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
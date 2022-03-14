package com.example.cinepul.cinepulapp.service;

/**
 * Created by christian on 06/11/2017.
 */

import com.example.cinepul.cinepulapp.domain.Client;

import java.util.List;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.POST;
import retrofit2.http.Path;

public interface ServiceClient {


    // requête d'appel des clients  GET
    @GET("client/getClients")
    Call<List<Client>>  getClients();
 //// requête d'ajout
       @POST("client/ajout")
       Call<Void> ajouterClient(@Body  Client unCl );
    //
    //    // requête de mise à jour
         @POST("client/modification")
         Call<Void> updateClient(@Body  Client unCl );
    //
    //    // requête de suppression
        @POST("client/deleteClient")
        Call<Void>  deleteClient(@Body  Client unCl );

}

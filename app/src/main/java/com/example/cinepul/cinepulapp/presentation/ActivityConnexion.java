package com.example.cinepul.cinepulapp.presentation;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.google.gson.Gson;

import com.example.cinepul.cinepulapp.MainActivity;
import com.example.cinepul.cinepulapp.domain.LoginParam;
import com.example.cinepul.cinepulapp.meserreurs.MonException;
import com.example.cinepul.cinepulapp.R;
import com.example.cinepul.cinepulapp.service.ServiceConnexion;
import com.example.cinepul.cinepulapp.service.RetrofitClient;
import com.google.gson.JsonSyntaxException;

import androidx.appcompat.app.AppCompatActivity;

import org.json.JSONException;
import org.json.JSONObject;

import okhttp3.OkHttpClient;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;

/**
 * Created by christian on 07/11/2017.
 */

public class ActivityConnexion extends AppCompatActivity implements View.OnClickListener {

    private EditText txtNom;
    private EditText txtPwd;
    private Button btValider;
    private Button btAnnuler;
    private String nom;
    private String pwd;
    private static final String TAG = "Connexion";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // On se relie au design
        setContentView(R.layout.activity_connexion);
        // on récupère le nom et le mot de passe
        txtNom = (EditText) findViewById(R.id.edLogin);
        txtPwd = (EditText) findViewById(R.id.edPwd);
        btValider = (Button) findViewById(R.id.btSignIn);
        btValider.setOnClickListener(this);
        btAnnuler = (Button) findViewById(R.id.btAnnuler);
        btAnnuler.setOnClickListener(this);

    }

    @Override
    public void onClick(View v) {
        this.nom = txtNom.getText().toString();
        this.pwd = txtPwd.getText().toString();
        Intent intent = new Intent(ActivityConnexion.this, MainActivity.class);
        int retour;
        if (v == btValider) {
            // Contrôle  de l'utilisateur

            LoginParam unLogin = new LoginParam(nom, pwd);
            controleUtilisateur(unLogin);
        } else if (v == btAnnuler){
            setResult(Activity.RESULT_CANCELED, intent);
            super.finish();
        }
    }

    public void controleUtilisateur(LoginParam unLogin) {
        boolean retour = false;
        OkHttpClient.Builder httpClient = new OkHttpClient.Builder();
        // On crée un adapteur rest sur l'url
        try {
            Retrofit retrofit = RetrofitClient.getClientRetrofit(this);
            ServiceConnexion uneConnexionService = retrofit.create(ServiceConnexion.class);
            // On appelle la méthode qui retourne les frais
            Call<Object> call = uneConnexionService.getConnexion(unLogin);

            // appel asynchrone
            call.enqueue(new Callback<Object>() {
                @Override
                public void onResponse(Call<Object> call, Response<Object> uneReponse) {
                    Log.d("receive",uneReponse.toString());

                    if (uneReponse.isSuccessful()) {
                        //Recupérer le corps de la reponse que Retrofit s'est chargé de désérialiser à notre place l'aide du convertor Gson
                        if (uneReponse.body() != null) {
                            Object unObjet = uneReponse.body();
                            String jsonString = (new Gson().toJson(unObjet));
                            JSONObject unJSO = null;
                            Log.d("receive",jsonString);
                            try {
                                unJSO = new JSONObject(jsonString);
                                String unToken = unJSO.getString("token");
                                Toast.makeText(ActivityConnexion.this, "Authentification réussie !!!", Toast.LENGTH_LONG).show();
                                stocke(unToken);
                            } catch (JSONException e) {
                                new MonException(e.getMessage(), "Erreur Appel WS Connexion");
                            }
                        } else {
                            Toast.makeText(ActivityConnexion.this, "Erreur d'appel!", Toast.LENGTH_LONG).show();
                        }

                    } else {
                        Toast.makeText(ActivityConnexion.this, "Erreur rencontrée", Toast.LENGTH_LONG).show();
                        Log.d(TAG, "onResponse =>>> code = " + uneReponse.code());
                    }
                }
                @Override
                public void onFailure(Call<Object> call, Throwable t) {
                    Toast.makeText(ActivityConnexion.this, "Erreur de connexion", Toast.LENGTH_LONG).show();
                }
            });
        } catch (IllegalStateException | JsonSyntaxException exception) {
            new MonException(exception.getMessage(), "Erreur Appel WS Connexion");
        } catch (Exception e) {
            new MonException(e.getMessage(), "Erreur Appel WS Connexion");
        }
    }

    // retour vers  les informations à la fenêtre principale
    private void stocke(String unTk) {
        int retour = 1;
        Intent intent = new Intent(ActivityConnexion.this, MainActivity.class);
        intent.putExtra("unToken", unTk);
        setResult(Activity.RESULT_OK, intent);
        super.finish();
    }


}
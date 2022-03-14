package com.example.cinepul.cinepulapp;

import android.content.Intent;
import android.content.SharedPreferences;
import android.content.Context;
import android.os.Bundle;

import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.example.cinepul.cinepulapp.presentation.ActivitySaisieClient;
import com.example.cinepul.cinepulapp.presentation.ActivityAfficheClient;
import com.example.cinepul.cinepulapp.presentation.ActivityConnexion;
import com.example.cinepul.cinepulapp.service.SessionManager;

import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {

    private Button btnListerClients;
    private Button btnQuitter;
    private Button btnConnexion;
    private Button btnAjouter;
    private TextView txtInfo;
    private String token;
    private int numero;

    public static final String MyPREFERENCES = "MyPrefs" ;
    private SharedPreferences sharedpreferences;
    private SessionManager  uneSession ;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        this.btnListerClients = findViewById(R.id.btListerClients);
        this.btnQuitter = findViewById(R.id.btRetour);
        this.btnConnexion = findViewById(R.id.btConnexion);
        this.btnAjouter = findViewById(R.id.btAjouter);

        this.btnListerClients.setOnClickListener(this);
        this.btnQuitter.setOnClickListener(this);
        this.btnConnexion.setOnClickListener(this);
        this.btnAjouter.setOnClickListener(this);

        this.btnListerClients.setEnabled(false);
        this.btnListerClients.setClickable(false);
        this.btnAjouter.setEnabled(false);
        this.btnAjouter.setClickable(true);
        this.txtInfo = findViewById(R.id.txtInfo);
        this.token = null;
        this.btnConnexion.setText("Connexion");
        this.txtInfo.setText("");

       uneSession = new SessionManager(this);
    }

    public void onClick(View v) {
        String information = "";


        if (v == btnConnexion) {
            Intent intent = new Intent(MainActivity.this, ActivityConnexion.class);
            startActivityForResult(intent, 1);
        }  else if (v == btnListerClients) {

           String unToken =uneSession.fetchAuthToken();
            String autho = "Bearer " + unToken;

            Intent intent = new Intent(MainActivity.this, ActivityAfficheClient.class);
            intent.putExtra("autho", autho);
            startActivityForResult(intent, 0);
        }
        else if (v == btnAjouter) {

            Intent intent = new Intent(MainActivity.this, ActivitySaisieClient.class);
            startActivityForResult(intent, 1);
        }

        else if (v == btnQuitter) {
            super.finish();
        }else {
            // display error
            String erreur = "erreur!";
        }

    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1) {
            switch (resultCode) {
                case MainActivity.RESULT_OK: {
                    if (data.hasExtra("unToken")) {
                        String  unToken = (String) data.getSerializableExtra("unToken");
                        this.txtInfo.setText(unToken);
                       // on sauve le token en session
                        uneSession.saveAuthToken(unToken);
                        // on met à jour les boutons
                        this.btnConnexion.setEnabled(false);
                        this.btnListerClients.setEnabled(true);
                        this.btnAjouter.setEnabled(true);
                        btnListerClients.setOnClickListener(this);
                        break;
                    } else
                        super.finish();
                }

                case 2   :  {
                    // information = (String) data.getExtras().get("information");
                    // this.txtInfo.setText(information);
                    this.btnConnexion.setEnabled(false);
                    this.btnListerClients.setEnabled(true);
                    this.btnAjouter.setEnabled(true);
                    break;

                }
            }
        }
    }
}



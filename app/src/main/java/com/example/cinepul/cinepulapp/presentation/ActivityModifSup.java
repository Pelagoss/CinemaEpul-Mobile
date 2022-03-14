package com.example.cinepul.cinepulapp.presentation;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.example.cinepul.cinepulapp.R;
import com.example.cinepul.cinepulapp.meserreurs.MonException;
import com.example.cinepul.cinepulapp.domain.Client;
import com.example.cinepul.cinepulapp.service.RetrofitClientBearer;
import com.example.cinepul.cinepulapp.service.ServiceClient;
import com.google.gson.JsonSyntaxException;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;

public class ActivityModifSup extends AppCompatActivity implements View.OnClickListener {

    private EditText txtNom;
    private EditText txtAdresse;
    private EditText txtVille;
    private EditText txtCpostal;
    private EditText txtNumPiece;
    private EditText txtTypePiece;


    private Button btSupprimer;
    private Button btModifier;
    private Button btAnnuler;
    private int retour = 0;

    private String nom;
    private String adresse;
    private String ville;
    private String cpostal;
    private String numPiece;
    private String typePiece;
    private int numeroClient;
    private int CODE_REQUEST = 1;// The request code
    private String information;
    private final String TAG = "Main Activity";
    private Client unClient;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_modif_sup);
        init();
    }

    private void init() {

        this.btAnnuler = findViewById(R.id.btAnnuler);
        this.btAnnuler.setOnClickListener(this);
        this.btModifier = findViewById(R.id.btModifier);
        this.btModifier.setOnClickListener(this);
        this.txtNom = findViewById(R.id.edNom);
        this.txtAdresse = findViewById(R.id.edAdresse);
        this.txtVille = findViewById(R.id.edVille);
        this.txtCpostal = findViewById(R.id.edCpostal);
        this.txtNumPiece = findViewById(R.id.edNumPiece);
        this.txtTypePiece = findViewById(R.id.edTypePiece);


        // transfet de données entre fenêtres

        // transfet de données entre fenêtres
        unClient = (Client) getIntent().getExtras().getSerializable("unClient");
        // on affiche les informationss
        this.numeroClient = unClient.getNumCli();
        txtNom.setText(unClient.getNomCli());
        txtAdresse.setText(unClient.getAdrRueCli());
        txtVille.setText(unClient.getVilleCli());
        txtCpostal.setText(unClient.getCpCli());
        txtNumPiece.setText(unClient.getNumPieceCli());
        txtTypePiece.setText(unClient.getPieceCli());

    }


    public void onClick(View v) {
        if (v == btAnnuler) {
            this.information = "Annulation  !";
            this.retour = 4; // annulation
            super.finish();
        } else if (v == btModifier) {
            nom = txtNom.getText().toString();
            adresse = txtAdresse.getText().toString();
            ville = txtVille.getText().toString();
            cpostal = txtCpostal.getText().toString();
            numPiece = txtNumPiece.getText().toString();
            typePiece = txtNumPiece.getText().toString();

            if (nom.equals("") || adresse.equals("") ||
                    ville == null || cpostal == null) {
                AlertDialog.Builder builder = new AlertDialog.Builder(ActivityModifSup.this);
                builder.setTitle("Erreur")
                        .setMessage(" Données absentes ")
                        .setIcon(android.R.drawable.ic_dialog_alert)
                        .setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                //Bouton cliqué, on affiche
                                Toast.makeText(ActivityModifSup.this, "Il faut saisir des données ", Toast.LENGTH_SHORT).show();
                            }
                        })
                        .show();
                information = "Données absentes !";
                retour = 3;  // données nulles
            } else {
                unClient = new Client(this.numeroClient,nom, adresse, ville, cpostal, numPiece, typePiece);
                modifierClient(unClient);
                information = "modificatication réussie !";
                retour = Activity.RESULT_OK;
            }
            Intent intent = new Intent(this, ActivityAfficheClient.class);
            intent.putExtra("information", information);
            setResult(retour, intent);
            super.finish();
        }
    }

    private void modifierClient(Client unClient) {
        String message = "";
        try {
            Retrofit retrofit = RetrofitClientBearer.getClientRetrofit(this);
            ServiceClient unClientService = retrofit.create(ServiceClient.class);
            // On appelle la méthode qui retourne les frais
            Call<Void> call = unClientService.updateClient(unClient);

            // appel asynchrone
            call.enqueue(new Callback<Void>() {
                @Override
                public void onResponse(Call<Void> call, Response<Void> uneReponse) {
                    if (uneReponse.isSuccessful()) {
                        //Recupérer le corps de la reponse que Retrofit s'est chargé de désérialiser à notre place l'aide du convertor Gson
                        if (uneReponse.code() ==200) {
                            Toast.makeText(ActivityModifSup.this, "modification  réussie!", Toast.LENGTH_LONG).show();
                        } else {
                            Toast.makeText(ActivityModifSup.this, "Erreur d'appel!", Toast.LENGTH_LONG).show();
                        }
                    } else {
                        //Toast.makeText(MainActivity.this, "Erreur rencontrée", Toast.LENGTH_LONG).show();
                        Log.d(TAG, "onResponse =>>> code = " + uneReponse.code());
                    }
                }
                @Override
                public void onFailure(Call<Void> call, Throwable t) {
                    Toast.makeText(ActivityModifSup.this, "Erreur de connexion", Toast.LENGTH_LONG).show();
                }
            });
        } catch (IllegalStateException | JsonSyntaxException exception) {
            new MonException(exception.getMessage(), "Erreur Appel WS Modification");
        } catch (Exception e) {
            new MonException(e.getMessage(), "Erreur Appel WS Modification");
        }
    }
}


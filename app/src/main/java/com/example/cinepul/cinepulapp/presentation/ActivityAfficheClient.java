package com.example.cinepul.cinepulapp.presentation;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.example.cinepul.cinepulapp.MainActivity;
import com.example.cinepul.cinepulapp.domain.Client;
import com.example.cinepul.cinepulapp.meserreurs.MonException;
import com.example.cinepul.cinepulapp.service.RetrofitClientBearer;
import com.example.cinepul.cinepulapp.service.ServiceClient;
import com.example.cinepul.cinepulapp.R;
import com.example.cinepul.cinepulapp.service.SessionManager;
import com.google.gson.JsonSyntaxException;

import java.util.List;

import androidx.appcompat.app.AppCompatActivity;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;


/**
 * Created by christian on 18/01/2017.
 */

public class ActivityAfficheClient extends AppCompatActivity implements View.OnClickListener {

    private static final String DEFAULT_QUERY = "Android";
    private static final String TAG = "Main Activity";
    private static final String NO_ERROR_VALUE = "0";
    private Button btRetour;
    private String auth;

    private List<Client> mesClients = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_affiche_client);
        btRetour = (Button) findViewById(R.id.btRetour);
        btRetour.setOnClickListener(this);
        loadClient();
    }

    public void onClick(View v) {
        String information = "";
        if (v == btRetour) {
            try {
                Intent intent = new Intent(this, MainActivity.class);
                this.finish();
            } catch (Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }

    @Override
    protected void onStart() {

        String information = "";
        super.onStart();
    }

    public void loadClient() {

        SessionManager uneSession = new SessionManager(this);
        String unToken = uneSession.fetchAuthToken();
        String autho = "Bearer " + unToken;
        try {
            Retrofit retrofit = RetrofitClientBearer.getClientRetrofit(this);
            // On crée un adapteur rest sur l'url
            ServiceClient unClientService = retrofit.create(ServiceClient.class);

            // On appelle la méthode qui retourne les frais
            Call<List<Client>> call = unClientService.getClients();

            // appel asynchrone
            call.enqueue(new Callback<List<Client>>() {

                @Override
                public void onResponse(Call<List<Client>> call, Response<List<Client>> uneReponse) {
                    if (uneReponse.isSuccessful()) {
                        //Recupérer le corps de la reponse que Retrofit s'est chargé de désérialiser à notre place l'aide du convertor Gson
                        if (uneReponse.body() != null) {
                            mesClients = uneReponse.body();
                            affiche(mesClients);
                        } else {
                            Toast.makeText(ActivityAfficheClient.this, "Erreur d'appel!", Toast.LENGTH_LONG).show();
                        }
                    } else {
                        //Toast.makeText(MainActivity.this, "Erreur rencontrée", Toast.LENGTH_LONG).show();
                        Log.d(TAG, "onResponse =>>> code = " + uneReponse.code());
                    }
                }

                @Override
                public void onFailure(Call<List<Client>> call, Throwable t) {
                    System.out.println("fail");
                    t.printStackTrace();
                    call.cancel();
                }
            });
        } catch (IllegalStateException | JsonSyntaxException exception) {
            new MonException(exception.getMessage(), "Erreur Appel WS Connexion");
        } catch (Exception e) {
            new MonException(e.getMessage(), "Erreur Appel WS Connexion");
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 0)
            auth = (String) data.getExtras().get("auth");
    }

    protected void affiche(List<Client> result) {

        ListView listViewData = (ListView) findViewById(R.id.lvClient);
        String data = "";
        TextView txtMessage = (TextView) findViewById(R.id.txMessage);
        String Error = null;
        mesClients = result;

        if (Error != null) {
            txtMessage.setText("Output : " + Error);
        } else {

            // On visualise la réponse sur l'écran (activity)
            txtMessage.setText("Voici le résultat");
            if (result != null) {
                listViewData.clearAnimation();
                LayoutInflater inflater = getLayoutInflater();
                ViewGroup header = (ViewGroup) inflater.inflate(R.layout.header, listViewData, false);
                if (listViewData.getHeaderViewsCount() == 0)
                    listViewData.addHeaderView(header, null, false);
                final ObjetAdapter adapter = new ObjetAdapter(ActivityAfficheClient.this, android.R.layout.simple_list_item_1, mesClients);
                listViewData.setAdapter(adapter);
                listViewData.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                    @Override
                    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                        Client unClient = mesClients.get(position - 1); // on récupère l'objet selectionné
                        // action
                        Intent intent = new Intent(ActivityAfficheClient.this, ActivityModifSup.class);
                        intent.putExtra("unClient", unClient);
                        startActivityForResult(intent, 1);
                    }
                });
            }

        }
    }


}


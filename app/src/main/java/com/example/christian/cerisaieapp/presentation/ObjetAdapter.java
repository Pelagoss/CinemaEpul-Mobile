package com.example.christian.cerisaieapp.presentation;

/**
 * Created by christian on 26/11/2016.
 */

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.example.christian.cerisaieapp.R;

import com.example.christian.cerisaieapp.domain.Client;


import java.util.List;

public class ObjetAdapter extends ArrayAdapter<Client> {

    private List<Client> mesClients ;

    private LayoutInflater layoutInflater;
    private Context context;

    public ObjetAdapter(Context context, int textViewResourceId, List<Client> mesCl) {
        super(context, textViewResourceId, mesCl);
        // On recopie la collection
        mesClients=mesCl;

        layoutInflater = LayoutInflater.from(context);
        this.context = context;
    }

    public View getView(int position, View convertView, ViewGroup parent) {
        // Get the current list item
        final Client item = mesClients.get(position);
        // Get the layout for the list item
        final LinearLayout itemLayout = (LinearLayout)
                LayoutInflater.from(context).inflate(R.layout.header, parent, false);
        // Set the text label as defined in our list item

        TextView txtnumCli = (TextView) itemLayout.findViewById(R.id.txtnumCli);
        txtnumCli.setText(String.valueOf(item.getNumCli())+ "   ");

        TextView txtnomCli = (TextView) itemLayout.findViewById(R.id.txtnomCli);
        txtnomCli.setText(item.getNomCli()+ "   ");

        TextView txtadrRueCli = (TextView) itemLayout.findViewById(R.id.txtadrRueCli);
        txtadrRueCli.setText(item.getAdrRueCli()+ "   ");

        TextView txtcpCli = (TextView) itemLayout.findViewById(R.id.txtcpCli);
        txtcpCli.setText(item.getCpCli()+ "   ");

        TextView txtvilleCli= (TextView) itemLayout.findViewById(R.id.txtvilleCli);
        txtvilleCli.setText(item.getVilleCli()+ "   ");

        TextView txtpieceCli= (TextView) itemLayout.findViewById(R.id.txtpieceCli);
        txtpieceCli.setText(item.getPieceCli()+ "   ");

        TextView txtnumPieceCli= (TextView) itemLayout.findViewById(R.id.txtnumPieceCli);
        txtnumPieceCli.setText(item.getNumPieceCli()+ "   ");

        return itemLayout;
    }
}

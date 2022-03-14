package com.example.cinepul.cinepulapp.domain;

/**
 * Created by christian on 14/11/2017.
 */

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;


@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonPropertyOrder({
        "numCli",
        "nomCli",
        "adrRueCli",
        "cpCli",
        "villeCli",
        "pieceCli",
        "numPieceCli"
})
public class Client implements java.io.Serializable{
    @JsonProperty("numCli")
    private int numCli;
    @JsonProperty("nomCli")
    private String nomCli;
    @JsonProperty("adrRueCli")
    private String adrRueCli;
    @JsonProperty("cpCli")
    private String cpCli;
    @JsonProperty("villeCli")
    private String villeCli;
    @JsonProperty("pieceCli")
    private String pieceCli;
    @JsonProperty("numPieceCli")
    private String numPieceCli;

    @JsonProperty("numCli")
    public int getNumCli() {
        return numCli;
    }
    @JsonProperty("numCli")
    public void setNumCli(int numCli) {
        this.numCli = numCli;
    }

    @JsonProperty("nomCli")
    public String getNomCli() {
        return nomCli;
    }
    @JsonProperty("nomCli")
    public void setNomCli(String nomCli) {
        this.nomCli = nomCli;
    }

    @JsonProperty("adrRueCli")
    public String getAdrRueCli() {
        return adrRueCli;
    }
    @JsonProperty("adrRueCli")
    public void setAdrRueCli(String adrRueCli) {
        this.adrRueCli = adrRueCli;
    }

    @JsonProperty("cpCli")
    public String getCpCli() {
        return cpCli;
    }
    @JsonProperty("cpCli")
    public void setCpCli(String cpCli) {
        this.cpCli = cpCli;
    }

    @JsonProperty("villeCli")
    public String getVilleCli() {
        return villeCli;
    }
    @JsonProperty("villeCli")
    public void setVilleCli(String villeCli) {
        this.villeCli = villeCli;
    }

    @JsonProperty("pieceCli")
    public String getPieceCli() {
        return pieceCli;
    }
    @JsonProperty("pieceCli")
    public void setPieceCli(String pieceCli) {
        this.pieceCli = pieceCli;
    }
    @JsonProperty("numPieceCli")
    public String getNumPieceCli() {
        return numPieceCli;
    }
    @JsonProperty("numPieceCli")
    public void setNumPieceCli(String numPieceCli) {
        this.numPieceCli = numPieceCli;
    }

    public Client(String nomCli, String adrRueCli, String cpCli, String villeCli, String pieceCli, String numPieceCli) {
        this.nomCli = nomCli;
        this.adrRueCli = adrRueCli;
        this.cpCli = cpCli;
        this.villeCli = villeCli;
        this.pieceCli = pieceCli;
        this.numPieceCli = numPieceCli;
    }

    public Client(int num, String nomCli, String adrRueCli, String villeCli, String cpCli,String pieceCli, String numPieceCli) {
       this.numCli=num;
        this.nomCli = nomCli;
        this.adrRueCli = adrRueCli;
        this.cpCli = cpCli;
        this.villeCli = villeCli;
        this.pieceCli = pieceCli;
        this.numPieceCli = numPieceCli;
    }
}


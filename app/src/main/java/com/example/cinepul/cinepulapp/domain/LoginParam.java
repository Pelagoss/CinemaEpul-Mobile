package com.example.cinepul.cinepulapp.domain;

import java.io.Serializable;

public class LoginParam  implements Serializable {
    String  nomUtil;
    String  motPasse ;

    public LoginParam( String login, String pwd) {
        this.nomUtil = login;
        this.motPasse = pwd;
    }

    public String getNomUtil() {
        return nomUtil;
    }

    public void setNomUtil(String nomUtil) {
        this.nomUtil = nomUtil;
    }

    public String getMotPasse() {
        return motPasse;
    }

    public void setMotPasse(String motPasse) {
        this.motPasse = motPasse;
    }

}
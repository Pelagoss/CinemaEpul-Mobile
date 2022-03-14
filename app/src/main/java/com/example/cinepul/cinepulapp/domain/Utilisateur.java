package com.example.cinepul.cinepulapp.domain;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

import java.io.Serializable;


@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonPropertyOrder({
        "numUtil",
        "nomUtil",
        "motPasse",
        "role"
})

public class Utilisateur implements Serializable {
    @JsonProperty("numUtil")
        private Integer numUtil;
    @JsonProperty("nomUtil")
        private String nomUtil;
    @JsonProperty("motPasse")
        private String motPasse;
    @JsonProperty("role")
        private String role;


    @JsonProperty("numUtil")
    public Integer getNumUtil() {
        return numUtil;
    }
    @JsonProperty("numUtil")
    public void setNumUtil(Integer numUtil) {
        this.numUtil = numUtil;
    }
    @JsonProperty("nomUtil")
    public String getNomUtil() {
        return nomUtil;
    }
    @JsonProperty("nomUtil")
    public void setNomUtil(String nomUtil) {
        this.nomUtil = nomUtil;
    }
    @JsonProperty("motPasse")
    public String getMotPasse() {
        return motPasse;
    }
    @JsonProperty("motPasse")
    public void setMotPasse(String motPasse) {
        this.motPasse = motPasse;
    }
    @JsonProperty("role")
    public String getRole() {
        return role;
    }
    @JsonProperty("role")
    public void setRole(String role) {
        this.role = role;
    }
}

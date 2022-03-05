import 'dart:collection';

import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:senpain/modeles/ligneCommande.dart';

import 'client.dart';

class Commande{
  int idCom = 0;
  Client client;
  DateTime date = DateTime.now();
  DateTime dateL = DateTime.now();

  // somme de la commande initial et la somme des retours
  double sommeS = 0;
  double sommeR = 0;

  double somme = 0;

  Commande(this.client,this.dateL);
  
  Map<String, dynamic> toJson() {
    return {"client": client.toString(), "date": date,"dateL": dateL};
  }

  @override
  String toString() =>
      'Commande(Id:$idCom, client: $client, date: $date, dateL: $dateL, somme: $somme)';

  Commande.fromJson(Map<String, dynamic> json)
      : idCom = json['id'] ?? json['id'],
        client = Client.fromJson(json['client']),
        dateL = DateTime.parse(json['date'].toString()),
        date = DateTime.parse(json['created_at'].toString());

  void setId(int val){
    this.idCom = val;
  }
  void setSommeS(double val){
    this.sommeS = val;
  }
  double getSommeS(){
    return sommeS;
  }
  void setSommeR(double val){
    this.sommeR = val;
  }
  double getSommeR(){
    return sommeR;
  }
  void setSomme(double val){
    this.sommeS = val;
  }
  double getSomme(){
    return sommeS;
  }
}
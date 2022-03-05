import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:senpain/modeles/commande.dart';
import 'package:senpain/modeles/client.dart';
import 'package:senpain/modeles/ligneCommande.dart';
import 'package:senpain/services/url.dart';

class ServiceLigneCommande {
  static var token = "";
  
  final _urlBase = "https://senpain.herokuapp.com/lignes";
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=utf-8",
    'Accept': 'application/json',
  };
  List donnees = List.empty(growable: true);

 // permet de  récupérer les employés les employés
  Future<List<LigneCommande>> getLigneCommandes() async {
    var url = Uri.parse(_urlBase);
    final response = await http.get(url,headers: headers);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<LigneCommande>((json) => LigneCommande.fromJson(json))
          .toList();
    } else {
      return throw Exception('Erreur pour le chargement desligne de commandes');
    }
  }

  Future<List<LigneCommande>> getLigneCom(int id) async {
    var url = Uri.parse(_urlBase+'?commande=$id');
    final response = await http.get(url,headers: headers);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<LigneCommande>((json) => LigneCommande.fromJson(json))
          .toList();
    } else {
      return throw Exception('Erreur pour le chargement desligne de commandes');
    }
  }
  // permet d'avoir le nombre de clients dans la base de donnée
  Future<int> getNombreLigneCommande() async{
    var url = Uri.parse(_urlBase);
    final response = await http.get(url,headers: headers);
    int nbre = 0;
    if (response.statusCode == 200) {
      List l = json.decode(response.body).cast<Map<String, dynamic>>()
          .map<LigneCommande>((json) => LigneCommande.fromJson(json))
          .toList();
      nbre = l.length;
    } else { 
      nbre = -1;
      throw Exception('Erreur pour le chargement des Ligne de commandes');
    }
     return nbre;
  }
  // permet d'ajouter un client dans la base de données
  void addLigneCommande(List<dynamic> list,int c) async {
    var url = Uri.parse(_urlBase);
    for(int i=0;i<list.length;i++){
      var response = await http.post(url,
          headers: headers,
          body: jsonEncode({
            "commande": c,
            "pain": list[i]['value'],
            "quantite": list[i]['quantite'],
            "retour": 0.0,
            })
          );
     }   
  }
  // add Retour pain
  void addRetour(int id,double quantite) async{
    var url = Uri.parse(_urlBase+'/'+id.toString());
    var response = await http.put(url,
        headers: headers,
        body: jsonEncode({
          "retour": quantite,
        }));
  }
  // permet de modifier un client
  void modifLigneCommande(LigneCommande com,int id) async{
    var url = Uri.parse(_urlBase+'/'+id.toString());
    var response = await http.put(url,
        headers: headers,
        body: jsonEncode({
          "pain": com.pain.idPain,
          "quantite":com.quantite,
          "retour": com.retour,
        }));
  }
  // permet de supprimer un client dans la base de donnée
  deleteLigneCommande(int id) async {
    var response = await http.delete(_urlBase+'/$id', headers: headers);
  }

}

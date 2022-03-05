import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:senpain/modeles/commande.dart';
import 'package:senpain/modeles/client.dart';
import 'package:senpain/services/url.dart';
import 'package:senpain/vues/commande/listeCommande.dart';

class ServiceCommande {
  static var token = "";
  
  final _urlBase = "https://senpain.herokuapp.com/commandes";
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=utf-8",
    'Accept': 'application/json',
  };
  List donnees = List.empty(growable: true);

 // permet de  récupérer les employés les employés
  Future<List<Commande>> getCommandes() async {
    var url = Uri.parse(_urlBase);
    final response = await http.get(url,headers: headers);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<Commande>((json) => Commande.fromJson(json))
          .toList();
    } else {
      return throw Exception('Erreur pour le chargement des commandes');
    }
  }
  // obtenir une commande
  Future<Commande> getCommande(int id) async {
    var url = Uri.parse(_urlBase+'/$id');
    final response = await http.get(url,headers: headers);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<Commande>((json) => Commande.fromJson(json))
          .toList();
    } else {
      return throw Exception('Erreur pour le chargement des commandes');
    }
  }
  // obtenir une commande du client id
  Future<List<Commande>> getComClient(int id) async {
    var url = Uri.parse(_urlBase+'?client=$id');
    final response = await http.get(url,headers: headers);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<Commande>((json) => Commande.fromJson(json))
          .toList();
    } else {
      return throw Exception('Erreur pour le chargement des commandes');
    }
  }
  // permet d'avoir le nombre de clients dans la base de donnée
  Future<int> getNombreCommande() async{
    var url = Uri.parse(_urlBase);
    final response = await http.get(url,headers: headers);
    int nbre = 0;
    if (response.statusCode == 200) {
      List l = json.decode(response.body).cast<Map<String, dynamic>>()
          .map<Commande>((json) => Commande.fromJson(json))
          .toList();
      nbre = l.length;
    } else { 
      nbre = -1;
      throw Exception('Erreur pour le chargement des commandes');
    }
     return nbre;
  }
  // permet d'ajouter un client dans la base de données
  void addCommande(Commande com) async {
    var url = Uri.parse(_urlBase);
    var response = await http.post(url,
        headers: headers,
        body: jsonEncode({
          "client": com.client.idClient,//com.client.getId(),
          "date": com.dateL.toString(),
          })
        );
  }
  // permet de modifier un client
  void modifCommande(Commande com,int id) async{
    var url = Uri.parse(_urlBase+'/'+id.toString());
    var response = await http.put(url,
        headers: headers,
        body: jsonEncode({
          "client": com.client.idClient,
          "date":com.dateL.toString().substring(0,10),
        }));
  }
  // permet de supprimer un client dans la base de donnée
  deleteCommande(int id) async {
    var response = await http.delete(_urlBase+'/$id', headers: headers);
  }

  // supp les commande d'un client
  deleteComClient(List<Commande> com) async {
    for(var c in com){
      var response = await http.delete(_urlBase+'/${c.idCom}', headers: headers);
    }
  }

  // le dernier element 
  

}

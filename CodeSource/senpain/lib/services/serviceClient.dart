import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:senpain/modeles/client.dart';
import 'package:senpain/services/url.dart';
import '../modeles/user.dart';


class ServiceClient {
  static var token = "";
  final _urlBase = "https://senpain.herokuapp.com/clients";
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=utf-8",
    'Accept': 'application/json',
  };
  List donnees = List.empty(growable: true);
  // permet de  récupérer les employés les employés
  Future<List<Client>> getClients() async {
    var url = Uri.parse(_urlBase);
    final response = await http.get(url,headers: headers);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<Client>((json) => Client.fromJson(json))
          .toList();
    } else {
      throw Exception('Erreur pour le chargement des Clients');
    }
  }
  // permet d'avoir le nombre de clients dans la base de donnée
  Future<int> getNombreClient() async{
    var url = Uri.parse(_urlBase);
    final response = await http.get(url,headers: headers);
    int nbre = 0;
    if (response.statusCode == 200) {
      List l = json.decode(response.body).cast<Map<String, dynamic>>()
          .map<Client>((json) => Client.fromJson(json))
          .toList();
      nbre = l.length;
    } else { 
      nbre = -1;
      throw Exception('Erreur pour le chargement des clients');
    }
     return nbre;
  }
  // permet d'ajouter un client dans la base de données
  addClient(Client client) async {
    var url = Uri.parse(_urlBase);
    var response = await http.post(url,
        headers: headers,
        body: jsonEncode({
          "nom": client.nom,
          "prenom":client.prenom,
          "telephone": client.telephone,
          "adresse": client.adresse,
        }));
  }
  // permet de modifier un client
  modifClient(Client client,int id) async{
    var url = Uri.parse(_urlBase+'/'+id.toString());
    var response = await http.put(url,
        headers: headers,
        body: jsonEncode({
          "nom": client.nom,
          "prenom":client.prenom,
          "telephone": client.telephone,
          "adresse": client.adresse,
        }));
  }
  // permet de supprimer un client dans la base de donnée
  deleteClient(int id) async {
    var response = await http.delete(_urlBase+'/$id', headers: headers);
  }

}

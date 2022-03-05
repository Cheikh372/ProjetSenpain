import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:senpain/modeles/pain.dart';
import 'package:senpain/services/url.dart';
import 'package:senpain/services/url.dart';
import 'package:senpain/vues/pain/listePain.dart';

class ServicePain {
  static var token = "";
  final _urlBase = "https://senpain.herokuapp.com/pains";
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=utf-8",
    'Accept': 'application/json',
  };
  List donnees = List.empty(growable: true);

  // permet de  récupérer les pains
  Future<List<Pain>> getPains() async {
    var url = Uri.parse(_urlBase);
    final response = await http.get(url,headers: headers);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<Pain>((json) => Pain.fromJson(json))
          .toList();
    } else {
      return throw Exception('Erreur pour le chargement des employés');
    }
  }

  // permet d'avoir le nombre de pains dans la base de donnée
  Future<int> getNombrePain() async{
    var url = Uri.parse(_urlBase);
    final response = await http.get(url,headers: headers);
    int nbre = 0;
    if (response.statusCode == 200) {
      List l = json.decode(response.body).cast<Map<String, dynamic>>()
          .map<Pain>((json) => Pain.fromJson(json))
          .toList();
      nbre = l.length;
    } else { 
      nbre = -1;
      throw Exception('Erreur pour le chargement des pains');
    }
     return nbre;
  }
  // permet d'ajouter un pain dans la base de données
 Future<bool> addPain(Pain pain) async {
    var url = Uri.parse(_urlBase);
    var response = await http.post(url,
        headers: headers,
        body: jsonEncode({
          "libele": pain.libele,
          "prix": pain.prix,
        }));
        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
  }
  // permet de modifier un pain
  modifPain(Pain pain,int id) async{
    var url = Uri.parse(_urlBase+'/'+id.toString());
    var response = await http.put(url,
        headers: headers,
        body: jsonEncode({
          "libele": pain.libele,
          "prix":pain.prix,
        }));
  }
  // permet de supprimer un pain dans la base de donnée
  deletePain(int id) async {
    var response = await http.delete(_urlBase+'/$id', headers: headers);
  }

}

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:senpain/modeles/employe.dart';
import 'package:senpain/services/url.dart';
import 'package:senpain/vues/pain/listePain.dart';
import '../modeles/user.dart';
import '../modeles/pain.dart';


class ServiceEmploye {
  static var token = "";
  final _urlBase = "https://senpain.herokuapp.com/employes";
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=utf-8",
    'Accept': 'application/json',
  };
  List donnees = List.empty(growable: true);

  // permet de  récupérer les employés les employés
  Future<List<Employe>> getEmployes() async {
    var url = Uri.parse(_urlBase);
    final response = await http.get(url,headers: headers);
    print(response.body);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<Employe>((json) => Employe.fromJson(json))
          .toList();
    } else {
      return throw Exception('Erreur pour le chargement des employés');
    }
  }

  // permet d'avoir le nombre d'emplyés dans la base de donnée
  Future<int> getNombreEmploye() async{
    var url = Uri.parse(_urlBase);
    final response = await http.get(url,headers: headers);
    int nbre = 0;
    if (response.statusCode == 200) {
      List l = json.decode(response.body).cast<Map<String, dynamic>>()
          .map<Employe>((json) => Employe.fromJson(json))
          .toList();
      nbre = l.length;
    } else { 
      nbre = -1;
      throw Exception('Erreur pour le chargement des employés');
    }
     return nbre;
  }
  // permet d'ajouter un employé dans la base de données
  addEmploye(Employe employe) async {
    var url = Uri.parse(_urlBase);
    var response = await http.post(url,
        headers: headers,
        body: jsonEncode({
          "nom": employe.nom,
          "prenom":employe.prenom,
          "telephone": employe.telephone,
          "adresse": employe.adresse,
        }));
  }
  // permet de modifier un employé
  modifEmploye(Employe employe,int id) async{
    var url = Uri.parse(_urlBase+'/'+id.toString());
    var response = await http.put(url,
        headers: headers,
        body: jsonEncode({
          "nom": employe.nom,
          "prenom":employe.prenom,
          "telephone": employe.telephone,
          "adresse": employe.adresse,
        }));
  }
  // permet de supprimer un employé dans la base de donnée
  deleteEmploye(int id) async {
    var response = await http.delete(_urlBase+'/$id', headers: headers);
  }

}

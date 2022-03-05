import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:senpain/services/url.dart';
import '../modeles/user.dart';


class ServiceUser {
  static var token = "";
  final _urlBase = "https://senpain.herokuapp.com/users";
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=utf-8",
    'Accept': 'application/json',
  };
  List donnees = List.empty(growable: true);

  // permet de récupérer les Users
  Future<List<User>> getUsers() async {
    var url = Uri.parse(_urlBase);
    final response = await http.get(url,headers: headers);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<User>((json) => User.fromJson(json))
          .toList();
    } else {
      throw Exception('Erreur de chargement des Users');
    }
  }

  /*Future<String> attemptLogIn(String username, String password) async {
    var url = Uri.parse(_urlBase);
    var res = await http.post(url,
      body: {
        "username": username,
        "password": password
      }
    );
    
    print(res.body) ;
    if(res.statusCode == 200){
      return  res.body;
      }
    else {
      return '';
    }
  }*/

  Future<String> authentification(String email, String pass) async {
    var url = Uri.parse('${urlBase}auth/local');
    http.Response response = await http.post(url,
        //headers: headers,
        body: {"identifier" : email, "password" : pass}
        );
    final responseData = jsonDecode(response.body);
    print(responseData);
    if (responseData["statusCode"] == null) {
      token = "Bearer ${responseData["jwt"]}";
      return  "ok";
    } else {
      return  "ko";
    }
  }
}

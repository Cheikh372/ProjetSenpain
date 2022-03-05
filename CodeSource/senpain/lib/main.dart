import 'package:flutter/material.dart';
import 'package:senpain/vues/accueil.dart';
import 'package:senpain/vues/client/listeClient.dart';
import 'package:senpain/vues/commande/detailCommande.dart';
import 'package:senpain/vues/commande/listeCommande.dart';
import 'package:senpain/vues/employe/listeEmploye.dart';
import 'package:senpain/vues/login.dart';
import 'package:senpain/vues/pain/listePain.dart';
import 'package:senpain/vues/user/listeUser.dart';

import 'modeles/commande.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SenPain',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        backgroundColor: Colors.cyan[900],
      ),
      home:  Login(),
      routes:{
        '/client': (context) => ListeClient(),
        '/employe': (context) => ListeEmploye(),
        '/pain': (context) => ListePain(),
        //'/user': (context) => ListeUser(),
        //'/gerant': (context) => ListeUser(),
        '/commande': (context) => ListeCommande(),
        '/accueil' : (context) => Accueil(),
        '/login' : (context) => Login(),
      }
    );
  }
}

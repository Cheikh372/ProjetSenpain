import 'dart:core';
import 'package:flutter/material.dart';
import 'package:senpain/vues/accueil.dart';

import 'pain/listePain.dart';
import '../services/serviceUser.dart';
import '../modeles/user.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String pass = '';
  String err = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  ServiceUser service = ServiceUser();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // pour le corps de la page login
      body: Container(
        // la décoration de la page de login
        /*decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                  'assets/images/logo.png'
                  ),
              fit: BoxFit.fill,
            ),
            borderRadius:BorderRadius.circular(80.0),
          ),*/
        // le formulaire de la page login
        child: Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Title(
                  color: Colors.black, 
                  child: Text(
                    "Connexion",
                    style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold),)),
                Text(err,
                  style: TextStyle(
                    color:Colors.red,
                    fontSize: 10,
                    ),
                  ),
                SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController, 
                  decoration: const InputDecoration(
                      labelText: " Votre émail",
                      hintText: ' Entrer adresse email',
                      labelStyle:TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        ),
                      ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Cette valeur ne peut être nulle !!!";
                    }
                  },
                  onSaved: (value) {
                    if (value != null) emailController.text = value;
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  obscureText: true,
                  controller: passController,
                  decoration: const InputDecoration(
                      labelText: "Votre mot de passe",
                      hintText: ' Entrer mot de pass',
                      ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Cette valeur ne peut être nulle !!!";
                    }
                  },
                  onSaved: (value) {
                    if (value != null) passController.text = value;
                  },
                ),
                SizedBox(height: 20,),
                MaterialButton(
                  minWidth: double.maxFinite,
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      String email = emailController.text;
                      String pass = passController.text;
                      var res = await service.authentification(email, pass);

                      passController.text = '';

                      if ( res != 'ok') {
                        setState(() {
                          err = 'mail ou mot de pass invalide !';
                        });
                        //Navigator.push(
                          //context,
                          //MaterialPageRoute(
                             // builder: (context) => const Login()),
                        //);
                      } else {
                        err = '';
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Accueil()),
                        );
                      }
                    }
                  },
                  color: Colors.cyan[900],
                  textColor: Colors.white,
                  child: const Text("Se connecter"),
                ),
              
              ],
            ),
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
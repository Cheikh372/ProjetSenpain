import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senpain/vues/employe/listeEmploye.dart';
import 'package:senpain/vues/login.dart';

class Navbar extends StatelessWidget {
 
  Color s = const Color(0xFF004D40);

  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero ,
        children: [
          DrawerHeader(
            child: CircleAvatar(
              backgroundColor: Colors.white,
            ),
            decoration: BoxDecoration(
              //color: Colors.red,
              gradient: LinearGradient(
                colors: [s,Colors.blue,s],
                ),
            ),
          ),
          SizedBox(height: 20,),
          ListTile(
            title: Text('Commandes'),
            leading: Icon(Icons.content_paste),
            focusColor: Colors.deepOrange,
            onTap: (){
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/commande');
            },
          ),
          const Divider(height: 10,thickness: 1.5,indent: 20,endIndent: 20,),
          ListTile(
            title: Text('Employes'),
            leading: Icon(Icons.people_alt),
            focusColor: Colors.deepOrange,
            onTap: (){
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/employe');
            }
          ),
          const Divider(height: 10,thickness: 1.5,indent: 20,endIndent: 20,),
          ListTile(
            title: Text('Clients'),
            leading: Icon(Icons.group_outlined),
            focusColor: Colors.deepOrange,
            onTap: (){
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/client');
            },
          ),
          
          const Divider(height: 10,thickness: 1.5,indent: 20,endIndent: 20,),
          ListTile(
            title: Text('Pain'),
            leading: Icon(Icons.home),
            focusColor: Colors.deepOrange,
            onTap: (){
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/pain');
            },
          ),
          /*const Divider(height: 20,thickness: 3,indent: 20,endIndent: 20,),
          ListTile(
            title: Text('Users'),
            leading: Icon(Icons.people_alt_outlined),
            focusColor: Colors.deepOrange,
            onTap: (){
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/user');
            },
          ),*/
          const Divider(height: 10,thickness: 1.5,indent: 20,endIndent: 20,),
          ListTile(
            title: Text('A propos'),
            leading: Icon(Icons.people_alt_outlined),
            focusColor: Colors.deepOrange,
            onTap: (){
              Navigator.of(context).pop();
              //Navigator.pushNamed(context, '/gerant');
            },
          ),
          const Divider(height: 5,thickness: 1.5,indent: 20,endIndent: 20,),
          ListTile(
            title: Text('Quitter'),
            leading: Icon(Icons.exit_to_app),
            focusColor: Colors.deepOrange,
            onTap: (){
              //Navigator.of(context).pop();
              seDeconncter(context);
            },
          ),
          const Divider(height: 0,thickness: 1.5,indent: 20,endIndent: 20,),
          
        ],
      ),
    );
  }

  seDeconncter(BuildContext context){
    showDialog(context:context, builder: (_){
          return AlertDialog(
            title: const Text('Se deconnecter et quitter l\'application',
            style: TextStyle(color: Colors.red, fontSize: 18,fontWeight: FontWeight.bold)),
            
            actions: <Widget>[
              TextButton(
                child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                // on afficher le formulaire pou modifier
                onPressed: () {
                 SystemNavigator.pop();
                 
                },
              ),
              TextButton(
                child: const Text('Non',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );   
        });
  }
}
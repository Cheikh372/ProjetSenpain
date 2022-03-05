import 'package:flutter/material.dart';
import 'package:senpain/vues/commande/listeCommande.dart';
import '../../menu.dart';
import '../../services/serviceUser.dart';
import '../../modeles/user.dart';
import 'login.dart';

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  
  late MediaQueryData data;

  @override
  void initState() {
    super.initState();
    
    }
 
  @override
  Widget build(BuildContext context) {
    data = MediaQuery.of(context);
    return Scaffold(
      drawer: Navbar(),
      appBar: PreferredSize( 
        preferredSize: Size.fromHeight(80.0),
        child : AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.cyan[900],
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        title: Text(
          " Accueil",
          style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
            onPressed: (){
              seDeconnecter(context);
            }, 
            icon: Icon(Icons.exit_to_app)
          ),
          SizedBox(width: 30,),
          ],
          
        
      ), 
      ),
      
      body: Container(
      
        child: GridView.count(
          crossAxisCount: 2,
          primary: false,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          padding: const EdgeInsets.all(35),
          
            children: <Widget>[
              Container(
                child: MaterialButton(
                  padding: const EdgeInsets.only(top: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.cyan,),
                    
                  ),
                  //visualDensity: VisualDensity.standard,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Icon(Icons.shopping_cart_outlined,
                      size: 70,
                      color: Colors.cyan[900],),
                      Text(
                        "Commandes",
                        style: TextStyle(
                          color:Colors.cyan[900],
                          fontSize: 20,
                          ),
                      ),
                    ]),
                  onPressed: (){
                    Navigator.pushNamed(context,'/commande');
                  },
                ),
              ),
              Container(
                child: MaterialButton(
                  //padding: const EdgeInsets.only(top: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.cyan,),
                    
                  ),
                  //visualDensity: VisualDensity.standard,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Icon(Icons.group_add_sharp,
                      size: 70,
                      color: Colors.cyan[900],),
                      Text(
                        "Clients",
                        style: TextStyle(
                          color:Colors.cyan[900],
                          fontSize: 20,
                          ),
                      ),
                    ]),
                  onPressed: (){
                    Navigator.pushNamed(context,'/client');
                  },
                ),
              ),
              Container(
                child: MaterialButton(
                  padding: const EdgeInsets.only(top: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.cyan,),
                    
                  ),
                  //visualDensity: VisualDensity.standard,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Icon(Icons.groups_sharp,
                      size: 70,
                      color: Colors.cyan[900],),
                      Text(
                        "Employés",
                        style: TextStyle(
                          color:Colors.cyan[900],
                          fontSize: 20,
                          ),
                      ),
                    ]),
                  onPressed: (){
                    Navigator.pushNamed(context,'/employe');
                  },
                ),
              ),
              Container(
                child: MaterialButton(
                  padding: const EdgeInsets.only(top: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.cyan,),
                    
                  ),
                  //visualDensity: VisualDensity.standard,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Icon(Icons.lunch_dining_outlined,
                      size: 70,
                      color: Colors.cyan[900],),
                      Text(
                        "Pains",
                        style: TextStyle(
                          color:Colors.cyan[900],
                          fontSize: 20,
                          ),
                      ),
                    ]),
                  onPressed: (){
                    Navigator.pushNamed(context,'/pain');
                  },
                ),
              ),
              
            ],
        
          
            
      ),
      
      ),
    );
  }

  void seDeconnecter(BuildContext context) {
    showDialog(context:context, builder: (_){
          return AlertDialog(
            title: const Text('Se deconnecter ',
            style: TextStyle(color: Colors.red, fontSize: 18,fontWeight: FontWeight.bold)),
            
            actions: <Widget>[
              TextButton(
                child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context,'/login',(_) => false);
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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:senpain/modeles/employe.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../services/serviceEmploye.dart';
import '../../modeles/employe.dart';
import '../../menu.dart';

class ListeEmploye extends StatefulWidget {
  const ListeEmploye({Key? key}) : super(key: key);

  @override
  _ListeEmployeState createState() => _ListeEmployeState();
}

class _ListeEmployeState extends State<ListeEmploye> {
  var _nomController = TextEditingController();
  var _prenomController = TextEditingController();
  var _telephoneController = TextEditingController();
  var _adresseController = TextEditingController();
  
  bool formValide = false;
  

  final _formkey = GlobalKey<FormState>();

  late Future<List<Employe>> futureEmployes;
  ServiceEmploye service = new ServiceEmploye();

  
  // pour integrer la barre de recherche
  Widget appBarTitle = new Text("Liste Employés", style: new TextStyle(color: Colors.white),);
  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
  final TextEditingController _searchQuery = new TextEditingController();
  List<Employe> _list = [];
  late bool _IsSearching;
  String _searchText = "";

  // pour initialiser _ListeClientState
  _ListeEmployeState(){
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      }
      else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    futureEmployes = service.getEmployes();
    _IsSearching = false;
    init();
    }
 
 // pour recuperer les client sous de forme de liste
  void init() async{
    _list = [];
    _list = await futureEmployes;
    setState(() {
    });
    }
 
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _formkey,
      appBar: buildBar(context),
      body: new ListView(
        padding: EdgeInsets.all(18),
        children: [
            Column(
              //children: appB,
            ),
            Column(
              children: _IsSearching ? _buildSearchList() : _buildList(),
            )
        ], 
      ),
    );
  }
  
  
  List<ListTile> _buildList() {
    
    return getListe(_list);
  }

  List<ListTile> _buildSearchList() {
    if (_searchText.isEmpty) {
      return getListe(_list);
    }
    else {
      List<Employe> _searchList = [];
      for (int i = 0; i < _list.length; i++) {
        Employe  name = _list.elementAt(i);
        if (name.prenom.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(name);
        }
      }
      return getListe(_searchList);
    }
  }

  PreferredSizeWidget buildBar(BuildContext context) {
    return new AppBar(
        iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        //centerTitle: true,
        title: appBarTitle,
        toolbarHeight: 80,
        backgroundColor: Colors.cyan[900],
        actions: <Widget>[
          new IconButton(icon: actionIcon, onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close, color: Colors.white,);
                this.appBarTitle = new TextFormField(
                  controller: _searchQuery,
                  style: new TextStyle(
                    color: Colors.white,

                  ),
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.white)
                  ),
                );
                _handleSearchStart();
              }
              else {
                _handleSearchEnd();
              }
            });
          },),
          IconButton(
            onPressed: (){
              // saisir employe
              Employe cl = Employe('', '', '', '');
              saisirEmploye(false,cl);
              setState(() {
                
              });
              
            }, 
            icon: Icon(Icons.person_add_alt_1_outlined)
          ),
        ]
    );
  }

  List<ListTile> getListe(List<Employe> elements){
    return  elements.map((element) => new ListTile(
    onTap: (){
      detailEmploye(element);
    },
    title: new Text(element.prenom+' '+element.nom),
    subtitle: new Text(element.telephone),
    trailing:Column(
        children: [
          Expanded(
          child: IconButton(
            onPressed: (){
              setState(() {
                supprimerEmploye(element,element.idEmp);
              });
            },
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.deepOrange,
            )),
        ),
    ],
    ),)).toList();
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(Icons.search, color: Colors.white,);
      this.appBarTitle =
      new Text("Liste Employés", style: new TextStyle(color: Colors.white),);
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

  void detailEmploye(Employe employe){
        showDialog(context:context, builder: (_){
          return AlertDialog(
            title: const Text('Voulez-vous modifier ?',
            style: TextStyle(color: Colors.deepOrange)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  Text(employe.prenom+' '+employe.nom,
                    style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold,)),
                  SizedBox(height: 15),
                  Text('ID :  Cl0'+employe.idEmp.toString()),
                  SizedBox(height: 15),
                  Text('Téléphone :  '+employe.telephone),
                  SizedBox(height: 15),
                  Text('Adresse : '+employe.adresse),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                // on afficher le formulaire pou modifier
                onPressed: () {
                  Navigator.of(context).pop();
                  saisirEmploye(true,employe,employe.idEmp);
                },
              ),
              TextButton(
                child: const Text('Non',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );   
        });

      }


   void supprimerEmploye(Employe employe,int id){
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title: const Text('Voulez-vous supprimer ?',
        style: TextStyle(color: Colors.deepOrange)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              Text(employe.prenom+' '+employe.nom,
                style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold,)),
              SizedBox(height: 15),
              Text('ID :  Cl0'+id.toString()),
              SizedBox(height: 15),
              Text('Téléphone :  '+employe.telephone),
              SizedBox(height: 15),
              Text('Adresse : '+employe.adresse),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            onPressed: () {
              service.deleteEmploye(id);
              Navigator.of(context).pop();
              Fluttertoast.showToast(
                  msg: "Client supprimé avec succès!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              
            },
          ),
          TextButton(
            child: const Text('Non',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );   
    });
  }

  void saisirEmploye(bool modif,[var e,var id]){
    showDialog(context: context, builder: (_){
      return Dialog(
        elevation: 10.0,
        child: SingleChildScrollView(
          padding:EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.max,children: [
              getTextField(TextInputType.text,"Veuiller saisir nom... ", "Saisir nom", _nomController, Icons.person,e.nom),
              getTextField(TextInputType.text,"Veuiller saisir prenom... ", "Saisir prenom", _prenomController, Icons.person,e.prenom),
              getTextField(TextInputType.text,"Veuiller saisir adresse...", "Saisir adresse", _adresseController, Icons.home,e.adresse),
              getTextField(TextInputType.number,"Veuiller saisir numero...telephone ?", "Saisir numero", _telephoneController, Icons.phone,e.telephone),
              SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    color: Colors.cyan[900],
                    child: Row(
                      children: [
                        Icon(Icons.add),
                        Text("Valider",style: TextStyle(color:Colors.white),),
                      ]),
                    onPressed: (){
                        final nom = _nomController.text;
                        final prenom = _prenomController.text;
                        final telephone = _telephoneController.text;
                        final adresse = _adresseController.text;
                        if(nom.isEmpty || prenom.isEmpty || telephone.isEmpty || adresse.isEmpty){
                          Fluttertoast.showToast(
                            msg: "Veuiller remplir tous les champs!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.deepOrange,
                            textColor: Colors.white,
                            fontSize: 16.0,
                        );
                        }else{
                          // permet de modifier un employé
                          Employe employe = Employe(nom,prenom,telephone,adresse);
                          if(modif){
                              service.modifEmploye(employe,id);
                            Fluttertoast.showToast(
                              msg: "Employé modifié avec succès!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0
                              );
                          }else{
                            // permet de d'ajouter un employé
                              service.addEmploye(employe);     
                            Fluttertoast.showToast(
                              msg: "Employé ajouté avec succès!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0
                              );
                          }
                          Navigator.pop(context);
                        //Navigator.pop(context);
                        }
                      }
                      // ici
                  ),
                  MaterialButton(
                    color: Colors.cyan[900],
                    child: Row(
                      children: [
                        Icon(Icons.delete_forever),
                        Text("Annuler",style: TextStyle(color:Colors.white),),
                      ]),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                ],),
            ],
          ),)
      );
    });
  }

   TextFormField getTextField(TextInputType type,String hint,String label,TextEditingController controller,IconData iconData ,[var val]){
    if(val.toString().isEmpty){
      controller.text = '';
    }else{
      controller.text = val;
    }
    return TextFormField(
      keyboardType: type,
      decoration: InputDecoration(
        prefixIcon:Icon(iconData),
        labelStyle: TextStyle(color : Colors.deepOrange,fontSize:20),
        hintText: hint,labelText:label,
      ),
      controller: controller,
    );
  }

  
  


/*
@override
 Widget build(BuildContext context) {
    futureEmployes = service.getEmployes();
    return Scaffold(
      //drawer: Navbar(),
      appBar:AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
          ),
        title: Text(
          "Les employés",
          style: TextStyle(color: Colors.white),
          ),
        toolbarHeight: 80,
        backgroundColor: Colors.cyan[900],
        actions: [
          IconButton(
            onPressed: (){
              Employe emp = Employe('', '', '', '');
              saisirEmploye(false,emp);
            }, 
            icon: Icon(Icons.person_add_alt_1_outlined)
          ),
          IconButton(
            onPressed: (){
              // le code pour chercher un employe  
            },
            icon: Icon(Icons.search),
          ),
        ],

        
      ),  
      // ici le code pour afficher la liste des différents types de pain
      body: FutureBuilder<List<Employe>>(
        future: futureEmployes,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => ListTile(
                  // ici le code pour afficher l'inégration des info pour un client
                onTap: (){
                  var id = snapshot.data![index].idEmp;
                  var nom = snapshot.data![index].nom;
                  var prenom = snapshot.data![index].prenom;
                  var tel = snapshot.data![index].telephone;
                  var adr = snapshot.data![index].adresse;
                  Employe e = Employe(nom,prenom,tel,adr);
                  detailEmplye(e,id);
                },
                leading: CircleAvatar(
                  foregroundColor: Colors.white,
                  radius: 30,
                  child: Text(
                    snapshot.data![index].nom[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      ),),
                ),
                title: Text(
                  "${snapshot.data![index].prenom}  ${snapshot.data![index].nom}",
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle:Text(snapshot.data![index].telephone),
                // pour l'icon de supprimession des employés
                trailing:Column(
                  children: [
                        Expanded(
                        child: IconButton(
                          onPressed: (){
                            var id = snapshot.data![index].idEmp;
                            var nom = snapshot.data![index].nom;
                            var prenom = snapshot.data![index].prenom;
                            var tel = snapshot.data![index].telephone;
                            var adr = snapshot.data![index].adresse;
                            Employe e = Employe(nom,prenom,tel,adr);
                            setState((){
                              supprimerEmploye(e,id);
                            });
                          },
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.deepOrange,
                          )),
                      ),
                  ],
                ),
              ),
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  thickness: 10,
                );
              },
      );
      } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
 
  TextFormField getTextField(TextInputType type,String hint,String label,TextEditingController controller,IconData iconData ,[var val]){
    if(val.toString().isEmpty){
      controller.text = '';
    }else{
      controller.text = val;
    }
    return TextFormField(
      keyboardType: type,
      decoration: InputDecoration(
        prefixIcon:Icon(iconData),
        labelStyle: TextStyle(color : Colors.deepOrange,fontSize:20),
        hintText: hint,labelText:label,
      ),
      controller: controller,
    );
  }

  // permet de saisir un employé
  void saisirEmploye(bool modif,[var e,var id]){
    showDialog(context: context, builder: (_){
      return Dialog(
        elevation: 10.0,
        child: SingleChildScrollView(
          padding:EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.max,children: [
              getTextField(TextInputType.text,"Veuiller saisir nom... ", "Saisir nom", _nomController, Icons.person,e.nom),
              getTextField(TextInputType.text,"Veuiller saisir prenom... ", "Saisir prenom", _prenomController, Icons.person,e.prenom),
              getTextField(TextInputType.text,"Veuiller saisir adresse...", "Saisir adresse", _adresseController, Icons.home,e.adresse),
              getTextField(TextInputType.number,"Veuiller saisir numero... ", "Saisir numero", _telephoneController, Icons.phone,e.telephone),
              SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    color: Colors.green,
                    child: Row(
                      children: [
                        Icon(Icons.add),
                        Text("Valider",style: TextStyle(color:Colors.white),),
                      ]),
                    onPressed: (){
                        final nom = _nomController.text;
                        final prenom = _prenomController.text;
                        final telephone = _telephoneController.text;
                        final adresse = _adresseController.text;
                        if(nom.isEmpty || prenom.isEmpty || telephone.isEmpty || adresse.isEmpty){
                          Fluttertoast.showToast(
                            msg: "Veuiller remplir tous les champs!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.deepOrange,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                        }else{
                          // permet de modifier un employé
                          Employe employe = Employe(nom,prenom,telephone,adresse);
                          if(modif){
                            setState(() {
                              service.modifEmploye(employe,id);
                            });
                            Fluttertoast.showToast(
                              msg: "Employé modifié avec succès!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0
                              );
                          }else{
                            // permet de d'ajouter un employé
                            setState(() {
                              service.addEmploye(employe);     
                            });
                            Fluttertoast.showToast(
                              msg: "Employé ajouté avec succès!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0
                              );
                          }
                          Navigator.pop(context);
                        //Navigator.pop(context);
                        }
                      }
                      // ici
                  ),
                  MaterialButton(
                    color: Colors.green,
                    child: Row(
                      children: [
                        Icon(Icons.delete_forever),
                        Text("Annuler",style: TextStyle(color:Colors.white),),
                      ]),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                ],),
            ],
          ),)
      );
    });
  }

      // pour supprimer enmploye
      void supprimerEmploye(Employe employe,int id){
        showDialog(context: context, builder: (_){
          return AlertDialog(
            title: const Text('Voulez-vous supprimer ?',
            style: TextStyle(color: Colors.deepOrange)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  Text(employe.prenom+' '+employe.nom,
                    style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold,)),
                  SizedBox(height: 15),
                  Text('ID :  Emp0'+id.toString()),
                  SizedBox(height: 15),
                  Text('Téléphone :  '+employe.telephone),
                  SizedBox(height: 15),
                  Text('Adresse : '+employe.adresse),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                onPressed: () {
                  setState((){
                    service.deleteEmploye(id);
                  });
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                      msg: "Employé supprimé avec succès!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  
                },
              ),
              TextButton(
                child: const Text('Non',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );   
        });
      }

      // pour détail employé et modification
      void detailEmplye(Employe employe,int id){
        showDialog(context: context, builder: (_){
          return AlertDialog(
            title: const Text('Voulez-vous modifier ?',
            style: TextStyle(color: Colors.deepOrange)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  Text(employe.prenom+' '+employe.nom,
                    style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold,)),
                  SizedBox(height: 15),
                  Text('ID :  Emp0'+id.toString()),
                  SizedBox(height: 15),
                  Text('Téléphone :  '+employe.telephone),
                  SizedBox(height: 15),
                  Text('Adresse : '+employe.adresse),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                // on afficher le formulaire pou modifier
                onPressed: () {
                  Navigator.of(context).pop();
                    saisirEmploye(true,employe,id);
                },
              ),
              TextButton(
                child: const Text('Non',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );   
        });

      }

*/
}


class ChildItem extends StatelessWidget {

  final Employe name;

  var _nomController = TextEditingController();
  var _prenomController = TextEditingController();
  var _telephoneController = TextEditingController();
  var _adresseController = TextEditingController();

  ServiceEmploye service = new ServiceEmploye();
  
  ChildItem(this.name);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      onTap: (){
        detailEmploye(name, name.idEmp, context);
      },
      title: new Text(this.name.prenom+' '+name.nom),
      subtitle: new Text(this.name.telephone),
      trailing:Column(
          children: [
            Expanded(
            child: IconButton(
              onPressed: (){
                supprimerEmploye(name, name.idEmp, context);
              },
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.deepOrange,
              )),
          ),
      ],
      ),
      ); 
  }

  void detailEmploye(Employe employe,int id,BuildContext context){
        showDialog(context:context, builder: (_){
          return AlertDialog(
            title: const Text('Voulez-vous modifier ?',
            style: TextStyle(color: Colors.deepOrange)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  Text(employe.prenom+' '+employe.nom,
                    style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold,)),
                  SizedBox(height: 15),
                  Text('ID :  Cl0'+id.toString()),
                  SizedBox(height: 15),
                  Text('Téléphone :  '+employe.telephone),
                  SizedBox(height: 15),
                  Text('Adresse : '+employe.adresse),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                // on afficher le formulaire pou modifier
                onPressed: () {
                  Navigator.of(context).pop();
                  saisirEmploye(true,context,employe,id);
                },
              ),
              TextButton(
                child: const Text('Non',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );   
        });

      }


   void supprimerEmploye(Employe employe,int id,BuildContext context){
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title: const Text('Voulez-vous supprimer ?',
        style: TextStyle(color: Colors.deepOrange)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              Text(employe.prenom+' '+employe.nom,
                style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold,)),
              SizedBox(height: 15),
              Text('ID :  Cl0'+id.toString()),
              SizedBox(height: 15),
              Text('Téléphone :  '+employe.telephone),
              SizedBox(height: 15),
              Text('Adresse : '+employe.adresse),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            onPressed: () {
              service.deleteEmploye(id);
              Navigator.of(context).pop();
              Fluttertoast.showToast(
                  msg: "Client supprimé avec succès!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              
            },
          ),
          TextButton(
            child: const Text('Non',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );   
    });
  }

  void saisirEmploye(bool modif,BuildContext context,[var e,var id]){
    showDialog(context: context, builder: (_){
      return Dialog(
        elevation: 10.0,
        child: SingleChildScrollView(
          padding:EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.max,children: [
              getTextField(TextInputType.text,"Veuiller saisir nom... ", "Saisir nom", _nomController, Icons.person,e.nom),
              getTextField(TextInputType.text,"Veuiller saisir prenom... ", "Saisir prenom", _prenomController, Icons.person,e.prenom),
              getTextField(TextInputType.text,"Veuiller saisir adresse...", "Saisir adresse", _adresseController, Icons.home,e.adresse),
              getTextField(TextInputType.number,"Veuiller saisir numero...telephone ?", "Saisir numero", _telephoneController, Icons.phone,e.telephone),
              SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    color: Colors.green,
                    child: Row(
                      children: [
                        Icon(Icons.add),
                        Text("Valider",style: TextStyle(color:Colors.white),),
                      ]),
                    onPressed: (){
                        final nom = _nomController.text;
                        final prenom = _prenomController.text;
                        final telephone = _telephoneController.text;
                        final adresse = _adresseController.text;
                        if(nom.isEmpty || prenom.isEmpty || telephone.isEmpty || adresse.isEmpty){
                          Fluttertoast.showToast(
                            msg: "Veuiller remplir tous les champs!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.deepOrange,
                            textColor: Colors.white,
                            fontSize: 16.0,
                        );
                        }else{
                          // permet de modifier un employé
                          Employe employe = Employe(nom,prenom,adresse,telephone);
                          if(modif){
                              service.modifEmploye(employe,id);
                            Fluttertoast.showToast(
                              msg: "Employé modifié avec succès!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0
                              );
                          }else{
                            // permet de d'ajouter un employé
                              service.addEmploye(employe);     
                            Fluttertoast.showToast(
                              msg: "Employé ajouté avec succès!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0
                              );
                          }
                          Navigator.pop(context);
                        //Navigator.pop(context);
                        }
                      }
                      // ici
                  ),
                  MaterialButton(
                    color: Colors.green,
                    child: Row(
                      children: [
                        Icon(Icons.delete_forever),
                        Text("Annuler",style: TextStyle(color:Colors.white),),
                      ]),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                ],),
            ],
          ),)
      );
    });
  }

   TextFormField getTextField(TextInputType type,String hint,String label,TextEditingController controller,IconData iconData ,[var val]){
    if(val.toString().isEmpty){
      controller.text = '';
    }else{
      controller.text = val;
    }
    return TextFormField(
      keyboardType: type,
      decoration: InputDecoration(
        prefixIcon:Icon(iconData),
        labelStyle: TextStyle(color : Colors.deepOrange,fontSize:20),
        hintText: hint,labelText:label,
      ),
      controller: controller,
    );
  }

  

}
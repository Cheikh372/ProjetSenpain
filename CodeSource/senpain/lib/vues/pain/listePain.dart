import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../services/servicePain.dart';
import '../../modeles/pain.dart';
import '../../menu.dart';

class ListePain extends StatefulWidget {
  const ListePain({Key? key}) : super(key: key);

  @override
  _ListePainState createState() => _ListePainState();
}

class _ListePainState extends State<ListePain> {
  var _libeleController = TextEditingController();
  var _prixController = TextEditingController();
  
  bool formValide = false;
  

  final _formkey = GlobalKey<FormState>();

  late Future<List<Pain>> futurePains;
  ServicePain service = new ServicePain();

  // pour integrer la barre de recherche
  Widget appBarTitle = new Text("Liste Pains", style: new TextStyle(color: Colors.white),);
  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
  final TextEditingController _searchQuery = new TextEditingController();
  List<Pain> _list = [];
  late bool _IsSearching;
  String _searchText = "";

  _ListePainState(){
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
    futurePains = service.getPains();
    _IsSearching = false;
    init();
    }

   // pour recuperer les client sous de forme de liste
  void init() async{
    _list = [];
    _list = await futurePains;
    setState(() {
    });
    }
  
  actualiser(){
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
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        onPressed: (){
            setState(() {
              actualiser();
            });
      }),
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
      List<Pain> _searchList = [];
      for (int i = 0; i < _list.length; i++) {
        Pain  name = _list.elementAt(i);
        if (name.libele.toLowerCase().contains(_searchText.toLowerCase())) {
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
              Pain cl = Pain('', '');
              saisirPain(false,cl);
              setState(() {
                
              });
              
            }, 
            icon: Icon(Icons.person_add_alt_1_outlined)
          ),
        ]
    );
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
      new Text("Liste Pains", style: new TextStyle(color: Colors.white),);
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

  List<ListTile> getListe(List<Pain> elements){
    return  elements.map((element) => new ListTile(
      onTap: (){
        detailPain(element);
      },
      title: new Text(element.libele),
      subtitle: new Text(element.prix+'  FCFA'),
      trailing:Column(
          children: [
            Expanded(
            child: IconButton(
              onPressed: (){
                setState(() {
                  supprimerPain(element,element.idPain);
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


  TextFormField getTextField(TextInputType type,String hint,String label,TextEditingController controller,[var val]){
    if(val.toString().isEmpty){
      controller.text = '';
    }else{
      controller.text = val;
    }
    return TextFormField(
      keyboardType: type,
      decoration: InputDecoration(
        labelStyle: TextStyle(color : Colors.deepOrange,fontSize:20),
        hintText: hint,labelText:label,
      ),
      controller: controller,
    );
  }

  // permet de saisir un type de pain
  void saisirPain(bool modif,[var e,var id]){
    showDialog(context: context, builder: (_){
      return Dialog(
        elevation: 10.0,
        child: SingleChildScrollView(
          padding:EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.max,children: [
              getTextField(TextInputType.text,"Veuiller saisir nom Pain... ", "Saisir nom pain", _libeleController,e.libele),
              getTextField(TextInputType.text,"Veuiller saisir prix... ", "Saisir prix", _prixController,e.prix),
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
                        final libele = _libeleController.text;
                        final prix = _prixController.text;
                        if(libele.isEmpty || prix.isEmpty){
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
                          Pain pain = Pain(libele,prix);
                          if(modif){
                            setState(() {
                              service.modifPain(pain,id);
                            });
                            Fluttertoast.showToast(
                              msg: "Pain modifié avec succès!",
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
                               service.addPain(pain);
                            });
                            Fluttertoast.showToast(
                              msg: "Pain ajouté avec succès!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0
                              );
                          }
                          Navigator.pop(context);
                        }
                      }
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

      // pour supprimer enmploye
  void supprimerPain(Pain pain,int id){
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title: const Text('Voulez-vous supprimer ?',
        style: TextStyle(color: Colors.deepOrange)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              Text(pain.libele,
                style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold,)),
              SizedBox(height: 15),
              Text('ID :  Pain0'+id.toString()),
              SizedBox(height: 15),
              Text('Prix :  '+pain.prix),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            onPressed: () {
              setState((){
                service.deletePain(id);
              });
              Navigator.of(context).pop();
              Fluttertoast.showToast(
                  msg: "Pain supprimé avec succès!",
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
  void detailPain(Pain pain){
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title: const Text('Voulez-vous modifier ?',
        style: TextStyle(color: Colors.deepOrange)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              Text(pain.libele,
                style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold,)),
              SizedBox(height: 15),
              Text('ID :  Pain0'+pain.idPain.toString()),
              SizedBox(height: 15),
              Text('Prix :  '+pain.prix),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            // on afficher le formulaire pou modifier
            onPressed: () {
              Navigator.of(context).pop();
                saisirPain(true,pain,pain.idPain);
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

}

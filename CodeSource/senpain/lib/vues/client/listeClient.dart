import 'dart:math';
import 'package:senpain/modeles/client.dart';
import 'package:senpain/menu.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:senpain/modeles/commande.dart';
import 'package:senpain/services/serviceClient.dart';
import 'package:senpain/services/serviceCommande.dart';
import 'package:senpain/vues/commande/detailCommande.dart';


class ListeClient extends StatefulWidget {
  const ListeClient({Key? key}) : super(key: key);

  @override
  _ListeClientState createState() => _ListeClientState();
}

class _ListeClientState extends State<ListeClient> {
  var _nomController = TextEditingController();
  var _prenomController = TextEditingController();
  var _telephoneController = TextEditingController();
  var _adresseController = TextEditingController();
  
  bool formValide = false;
  

  final _formkey = GlobalKey<FormState>();

  late Future<List<Client>> futureClients;
  ServiceClient service = new ServiceClient();
  ServiceCommande serviceCom = new ServiceCommande();
  
  // pour integrer la barre de recherche
  Widget appBarTitle = new Text("Liste Clients", style: new TextStyle(color: Colors.white),);
  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
  final TextEditingController _searchQuery = new TextEditingController();
  List<Client> _list = [];
  late bool _IsSearching;
  String _searchText = "";
  
  // pour initialiser _ListeClientState
  _ListeClientState(){
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
    futureClients = service.getClients();
    _IsSearching = false;
    init();
    }
    
  // pour recuperer les client sous de forme de liste
  void init() async{
    _list = [];
    _list = await futureClients;
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
      List<Client> _searchList = [];
      for (int i = 0; i < _list.length; i++) {
        Client  name = _list.elementAt(i);
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
              Client cl = Client('', '', '', '');
              saisirClient(false,cl);
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
      new Text("Liste Client", style: new TextStyle(color: Colors.white),);
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

List<ListTile> getListe(List<Client> elements){
  return  elements.map((element) => new ListTile(
      onTap: (){
        detailClient(element);
      },
      title: new Text(element.prenom+' '+element.nom),
      subtitle: new Text(element.telephone),
      trailing:Column(
          children: [
            Expanded(
            child: IconButton(
              onPressed: (){
                setState(() {
                  supprimerClient(element,element.idClient);
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

    // pour supprimer enmploye
  void supprimerClient(Client client,int id) async{
    List<Commande> com = await serviceCom.getComClient(id);
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title: const Text('Voulez-vous supprimer ?',
        style: TextStyle(color: Colors.deepOrange)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              Text(client.prenom+' '+client.nom,
                style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold,)),
              SizedBox(height: 10),
              Text('ID :  Cl0'+id.toString()),
              SizedBox(height: 10),
              Text('Nom : '+ client.prenom.toUpperCase()+' '+client.nom),
              SizedBox(height: 10),
              Text('Téléphone :  '+client.telephone),
              SizedBox(height: 10),
              Text('Adresse : '+client.adresse),
              SizedBox(height: 10),
              Text('Cette action supprime tous les commandes ce client.',style: TextStyle(color: Colors.red, fontSize: 17),),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            onPressed: () {
              setState((){
                service.deleteClient(id);
                serviceCom.deleteComClient(com);
              });
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

  // pour détail employé et modification
  void detailClient(Client client){
        showDialog(context: context, builder: (_){
          return AlertDialog(
            title: const Text('Voulez-vous modifier ?',
            style: TextStyle(color: Colors.deepOrange)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  Text(client.prenom+' '+client.nom,
                    style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold,)),
                  SizedBox(height: 15),
                  Text('ID :  Cl0'+client.idClient.toString()),
                  SizedBox(height: 15),
                  Text('Téléphone :  '+client.telephone),
                  SizedBox(height: 15),
                  Text('Adresse : '+client.adresse),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                // on afficher le formulaire pou modifier
                onPressed: () {
                  Navigator.of(context).pop();
                    saisirClient(true,client,client.idClient);
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
  // permet de saisir un client
  void saisirClient(bool modif,[var e,var id]){
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
                        Icon(Icons.add,color: Colors.white,),
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
                          Client client = Client(nom,prenom,adresse,telephone);
                          if(modif){
                            setState(() {
                              service.modifClient(client,id);
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
                              service.addClient(client);     
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
                    color: Colors.cyan[900],
                    child: Row(
                      children: [
                        Icon(Icons.delete_forever,color: Colors.white,),
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

 /* @override
  Widget build(BuildContext context) {
    futureClients = service.getClients();
    return Scaffold(
      //drawer: Navbar(),
      appBar:AppBar(
        iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        title: Text(
          "Les clients",
          style: TextStyle(color: Colors.white),
          ),
        toolbarHeight: 80,
        backgroundColor: Colors.cyan[900],
        actions: [
          IconButton(
            onPressed: (){
              Client cl = Client('', '', '', '');
              setState(() {
                saisirClient(false,cl);  
              });
              
            }, 
            icon: Icon(Icons.person_add_alt_1_outlined)
          ),
          IconButton(
            onPressed: (){
              // le code pour chercher un client
                
            },
            icon: Icon(Icons.search),
          ),
        ],    
      ),  
      body: FutureBuilder<List<Client>>(
        future: futureClients,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => ListTile(
                  // ici le code pour afficher l'inégration des info pour un client
                onTap: (){
                  var id = snapshot.data![index].idClient;
                  var nom = snapshot.data![index].nom;
                  var prenom = snapshot.data![index].prenom;
                  var tel = snapshot.data![index].telephone;
                  var adr = snapshot.data![index].adresse;
                  Client c = Client(nom,prenom,adr,tel);
                  detailClient(c,id);
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
                subtitle:Text(snapshot.data![index].telephone.toString()),
                // pour l'icon de supprimession des clients
                trailing:Column(
                  children: [
                        Expanded(
                        child: IconButton(
                          onPressed: (){
                            var id = snapshot.data![index].idClient;
                            var nom = snapshot.data![index].nom;
                            var prenom = snapshot.data![index].prenom;
                            var tel = snapshot.data![index].telephone;
                            var adr = snapshot.data![index].adresse;
                            Client c = Client(nom,prenom,adr,tel);
                            setState((){
                              supprimerClient(c,id);
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

  // permet de saisir un client
  void saisirClient(bool modif,[var e,var id]){
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
                            fontSize: 16.0
                        );
                        }else{
                          // permet de modifier un employé
                          Client client = Client(nom,prenom,adresse,telephone);
                          if(modif){
                            setState(() {
                              service.modifClient(client,id);
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
                              service.addClient(client);     
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
  void supprimerClient(Client client,int id){
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title: const Text('Voulez-vous supprimer ?',
        style: TextStyle(color: Colors.deepOrange)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              Text(client.prenom+' '+client.nom,
                style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold,)),
              SizedBox(height: 15),
              Text('ID :  Cl0'+id.toString()),
              SizedBox(height: 15),
              Text('Téléphone :  '+client.telephone),
              SizedBox(height: 15),
              Text('Adresse : '+client.adresse),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            onPressed: () {
              setState((){
                service.deleteClient(id);
              });
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

  // pour détail employé et modification
  void detailClient(Client client,int id){
        showDialog(context: context, builder: (_){
          return AlertDialog(
            title: const Text('Voulez-vous modifier ?',
            style: TextStyle(color: Colors.deepOrange)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  Text(client.prenom+' '+client.nom,
                    style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold,)),
                  SizedBox(height: 15),
                  Text('ID :  Cl0'+id.toString()),
                  SizedBox(height: 15),
                  Text('Téléphone :  '+client.telephone),
                  SizedBox(height: 15),
                  Text('Adresse : '+client.adresse),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                // on afficher le formulaire pou modifier
                onPressed: () {
                  Navigator.of(context).pop();
                    saisirClient(true,client,id);
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

class ChildItem extends StatelessWidget {

  final Client name;

  var _nomController = TextEditingController();
  var _prenomController = TextEditingController();
  var _telephoneController = TextEditingController();
  var _adresseController = TextEditingController();

  ServiceClient service = new ServiceClient();
  
  ChildItem(this.name);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      onTap: (){
        detailClient(name, name.idClient, context);
      },
      title: new Text(this.name.prenom+' '+name.nom),
      subtitle: new Text(this.name.telephone),
      trailing:Column(
          children: [
            Expanded(
            child: IconButton(
              onPressed: (){
                supprimerClient(name, name.idClient, context);
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

  void detailClient(Client client,int id,BuildContext context){
        showDialog(context:context, builder: (_){
          return AlertDialog(
            title: const Text('Voulez-vous modifier ?',
            style: TextStyle(color: Colors.deepOrange)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  Text(client.prenom+' '+client.nom,
                    style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold,)),
                  SizedBox(height: 15),
                  Text('ID :  Cl0'+id.toString()),
                  SizedBox(height: 15),
                  Text('Téléphone :  '+client.telephone),
                  SizedBox(height: 15),
                  Text('Adresse : '+client.adresse),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                // on afficher le formulaire pou modifier
                onPressed: () {
                  Navigator.of(context).pop();
                  saisirClient(true,context,client,id);
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


   void supprimerClient(Client client,int id,BuildContext context){
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title: const Text('Voulez-vous supprimer ?',
        style: TextStyle(color: Colors.deepOrange)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              Text(client.prenom+' '+client.nom,
                style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold,)),
              SizedBox(height: 15),
              Text('ID :  Cl0'+id.toString()),
              SizedBox(height: 15),
              Text('Téléphone :  '+client.telephone),
              SizedBox(height: 15),
              Text('Adresse : '+client.adresse),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            onPressed: () {
              service.deleteClient(id);
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

  void saisirClient(bool modif,BuildContext context,[var e,var id]){
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
                          Client client = Client(nom,prenom,adresse,telephone);
                          if(modif){
                              service.modifClient(client,id);
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
                              service.addClient(client);     
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
*/
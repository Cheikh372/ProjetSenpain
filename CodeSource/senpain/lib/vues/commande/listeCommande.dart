// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:date_field/date_field.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Dart:async';
import 'package:http/http.dart' as http;
import 'package:senpain/modeles/client.dart';
import 'package:senpain/modeles/pain.dart';
import 'package:senpain/services/serviceClient.dart';
import 'package:senpain/services/servicePain.dart';
import 'package:senpain/services/serviceLigneCommande.dart';
import 'package:senpain/vues/commande/detailCommande.dart';
import '../../menu.dart';
import '../../services/serviceCommande.dart';
import '../../modeles/commande.dart';
import '../../modeles/ligneCommande.dart';
import 'detailCommande.dart';

class ListeCommande extends StatefulWidget {
  const ListeCommande({Key? key}) : super(key: key);

  @override
  _ListeCommandeState createState() => _ListeCommandeState();
}

class _ListeCommandeState extends State<ListeCommande> {
  
  late Future<List<Commande>> futureCommandes;
  late Future<List<Client>> futureClients;
  late Future<List<Pain>> futurePains;
  late Future<List<LigneCommande>> futureLigne;

  ServiceCommande service = ServiceCommande();
  ServiceClient serviceCl = ServiceClient();
  ServicePain servicepain = ServicePain();
  ServiceLigneCommande servicelignecommande = ServiceLigneCommande();


   // pour integrer la barre de recherche
  Widget appBarTitle = new Text("Liste Commandes", style: new TextStyle(color: Colors.white),);
  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
  final TextEditingController _searchQuery = new TextEditingController();
  List<Commande> _list = [];
  late bool _IsSearching;
  String _searchText = "";

  // pour une commande
  late DateTime date = DateTime(0);
  Client cl = Client('', '','','');
  late Pain pain;
  late int quantite = 0;

  // pour la somme des ligne de commande
  int som = 0;
  bool nouveau = true;
  bool rafresh = false;



  int dernierId=0;

  TextEditingController controllerQu = TextEditingController();
  TextEditingController controllerPain = TextEditingController();
  var controllerP = TextEditingValue();
  
  // pour les options de pains à choisir
  
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  // initialiser _ListeCommandeState
  _ListeCommandeState(){
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
    futureCommandes = service.getCommandes();
    futureClients = serviceCl.getClients();
    futurePains = servicepain.getPains();
     _IsSearching = false;
    init();
    }

  // permet de recuperer le future sous forme de liste 
  void init() async{
    _list = [];
    _list = await futureCommandes;
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
            print('rrrr');
          });
      }),
    );
  }
 
  void actualiser(){
   setState(() {});
 }

  List<ListTile>  _buildList() {
    
    return getListe(_list);
  }

  List<ListTile> _buildSearchList() {
    if (_searchText.isEmpty) {
      return getListe(_list);
    }
    else {
      List<Commande> _searchList = [];
      for (int i = 0; i < _list.length; i++) {
        Commande  com = _list.elementAt(i);
        if (com.client.prenom.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(com);
        }
      }
      return getListe(_searchList);
    }
  }

  List<ListTile> getListe(List<Commande> elements){
  return  elements.map((element) => new ListTile(
      onTap: (){
        setState(() {
          detailCom(element);
        });
      },
      title: new Text('Com'+element.idCom.toString()+' par '+ element.client.prenom  +' '+element.client.nom),
      subtitle: new Text(element.dateL.toString()),
      trailing:Column(
          children: [
            Expanded(
            child: IconButton(
              onPressed: (){
                setState(() {
                  supprimerCommande(element,element.idCom);
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
               // pour saisir commande
               setState(() {
                 saisirCommande(false);
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
      new Text("Liste Commandes", style: new TextStyle(color: Colors.white),);
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

 void detailCom(Commande commande) {
    Navigator.push(
    context, 
    MaterialPageRoute<void>(
    builder:(BuildContext context) { 
        return DetailCommande(commande: commande);
    }));
                 
  }

  void supprimerCommande(Commande com,int id){
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title: const Text('Voulez-vous supprimer ?',
        style: TextStyle(color: Colors.deepOrange)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              Text('ID :  Com0'+com.idCom.toString(),),
              SizedBox(height: 10),
              Text('Date Com. :  '+com.date.day.toString()+'-'+com.date.month.toString()+'-'+com.date.year.toString()),
              SizedBox(height: 10),
              Text('Date Liv. :  '+com.dateL.day.toString()+'-'+com.dateL.month.toString()+'-'+com.dateL.year.toString()),
              SizedBox(height: 10),
              Text('Client :  '+com.client.prenom+' '+com.client.nom),
              SizedBox(height: 10),
              Text('Téléphone : '+com.client.telephone),
              SizedBox(height: 10),
              Text('Adresse  : '+com.client.adresse),
              SizedBox(height: 10),
              ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            onPressed: () {
              setState(() {
                service.deleteCommande(id);
                Navigator.of(context).pop();
              });
              Fluttertoast.showToast(
                  msg: "Commande supprimé avec succès!",
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

Widget _buildAddButton() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: Colors.pinkAccent,
      ),
      
    );
  }
 /*
  @override
  Widget build(BuildContext context) {
    futureCommandes = service.getCommandes();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        title: Text(
          "Les commandes",
          style: TextStyle(color: Colors.white),
          ),
        backgroundColor: Colors.cyan[900],
        toolbarHeight: 80,
        actions: [
          IconButton(
            onPressed: (){
              Commande emp = Commande(Client('','','',''),DateTime(1));
              saisirCommande(false,emp);
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
      body: FutureBuilder<List<Commande>>(
        future: futureCommandes,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => ListTile(      
                onTap: (){
                  var id = snapshot.data![index].idCom;
                  var som = snapshot.data![index].sommeS;
                  Client cl = snapshot.data![index].client;
                  var date = snapshot.data![index].date;
                  
                  Commande com = Commande(cl,date);
                  com.setId(id);
                  com.setSommeS(som);
                  //com.setLigneCommande(lign);
                  //detailCommande(context,com);
                  setState(() {
                    Navigator.push(
                    context, 
                    MaterialPageRoute<void>(
                    builder:(BuildContext context) { 
                      return DetailCommande(commande: com);
                    }));
                  });
                  },          
                title: Text(
                  "Com0${snapshot.data![index].idCom}  fait par  ${snapshot.data![index].client.prenom}",
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                subtitle: Text(snapshot.data![index].date.toString()),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: IconButton(
                          onPressed: () {
                            // pour supprimer
                          },
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.deepOrange,
                          )
                          ),
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
      /*floatingActionButton: FloatingActionButton(
        onPressed: (){},//addRetour(),
        backgroundColor: Colors.cyan[900],
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),*/
    );
  }
*/

  // permet de saisir un employé
  void saisirCommande(bool modif,[var com,var id]) async{
    
    String _displayStringForOption(Client option) => option.prenom +' '+option.nom+' '+option.telephone;
    // pour la liste déroulante pour les commande
    List<Client> _userOptions = await futureClients;
    List<Commande> list = await futureCommandes;
    List<Pain> _pain = await futurePains;

    List<dynamic> pains = <dynamic>[];
    List<dynamic> actuel = <dynamic>[];
    int long=0;

    if(list.length==0)
    {
      dernierId = 1;
    }else{
      if(nouveau){
      dernierId = list.last.idCom;
      dernierId = dernierId + 1; 
      }else{
        dernierId = dernierId + 1;
      }
    }
    

    String errCom = '';

    showDialog(context: context, builder: (_){
      DateTime selectedDate = DateTime.now();
      return Dialog(
        elevation: 10.0,
        child: SingleChildScrollView(
          padding:EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Title(color: Colors.red, child: Text("Saisir Commande :",style: TextStyle(color: Colors.red,fontSize: 17,fontWeight: FontWeight.bold),)),
              SizedBox(height: 10,),
              Text(errCom,style: TextStyle(color: Colors.red),),
              // pour laa liste déroulante 
              SizedBox(height: 20,),
              Text("Client :"),
              Autocomplete<Client>(
                displayStringForOption: _displayStringForOption,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    cl = Client('', '', '', '');
                    return const Iterable<Client>.empty();
                  }
                  return _userOptions
                            .where((Client option) => option.prenom.toLowerCase()
                            .toString()
                            .contains(textEditingValue.text.toLowerCase())
                          ).toList();
                },
                onSelected: (Client selection) {
                  // le client selectionné
                  cl = selection;
                  print(cl);
                },
                ),
                SizedBox(height: 20),
                
                FlutterTagging(
                  textFieldDecoration: InputDecoration(
                      hintText: "Pains",
                      labelText: "Entrer pain"),
                  addButtonWidget: null,//_buildAddButton(),
                  chipsColor: Colors.pinkAccent,
                  chipsFontColor: Colors.white,
                  keepSuggestionsOnLoading:false,
                  deleteIcon: Icon(Icons.cancel,color: Colors.white),
                  chipsPadding: EdgeInsets.all(2.0),
                  chipsFontSize: 14.0,
                  chipsSpacing: 5.0,
                  chipsFontFamily: 'helvetica_neue_light',
                  suggestionsCallback: (pattern) async {
                    return await Pain.getSuggestions(pattern,pains);  
                    },
                  onChanged: (result) {
                    setState(() {
                      pains = result;
                      if(pains.length>long){
                        long= long +1;
                        ajouterLigne(actuel, pains);
                      }else{
                        long = long-1;
                      }

                    });
                    },
                ),
                SizedBox(height: 25),
                // ici pour la date de livraison 
                Text("Date livraison :"),
                SizedBox(height: 10),
                DateTimeFormField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    //border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.event_note),
                    labelText: 'Date livraison',
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (e) => (e?.day ?? 0) == 1 ? 'veuillez entrer le jour !' : null,
                  onDateSelected: (DateTime value) {
                    date = value;
                  },
                ),
              
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    color: Colors.cyan[900],
                    child: Row(
                      children: [
                        Icon(Icons.add,color: Colors.white),
                        Text("Valider",style: TextStyle(color:Colors.white),),
                      ]),
                    onPressed: (){

                        if(pains.length != 0 && cl.nom!='' ){
                          setState(() {
                            Commande com = Commande(cl,date);
                            com.setId(dernierId);
                            service.addCommande(com);
                            nouveau = false;
                            List<dynamic> ligne = [];
                            print('eeeeeee');
                            for(int i=0; i<pains.length;i++){
                              for(int j=0;j<actuel.length;j++){
                                if(pains[i]['name'] == actuel[j]['name']){
                                  pains[i]['quantite'] = actuel[j]['quantite'];
                                }
                              }
                            }
                            print(pains);
                            servicelignecommande.addLigneCommande(pains, dernierId);
                            Navigator.pop(context);
                          });

                        }else{
                          setState(() {
                            Fluttertoast.showToast(
                              msg: "Erreur : Entrer tous les champs ",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.red,
                              fontSize: 16.0
                            );
                          });

                        }
                    },
                  ),
                  MaterialButton(
                    color: Colors.cyan[900],
                    child: Row(
                      children: [
                        Icon(Icons.delete_forever,color: Colors.white,),
                        Text("Terminer",style: TextStyle(color:Colors.white),),
                      ]),
                    onPressed: (){
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],),
            ]

        )
      ),
      );
    });
  }

  ajouterLigne(List<dynamic> actuel, List<dynamic> pains){
    showDialog(context: context, builder: (_){
    return Dialog(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
              SizedBox(height: 10),
              Text("Entrer quantité  "+pains.last['name'],
              style: TextStyle(color: Colors.deepOrange,fontSize: 15,fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon:Icon(Icons.production_quantity_limits_outlined),
                labelStyle: TextStyle(color : Colors.black,fontSize:20),
                hintText: 'quantite',labelText:'Quantite',
              ),
              controller: controllerQu,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Cette valeur ne peut être nulle !!!";

                }
              },
              onSaved: (value) {
                if (value != null) 
                  controllerQu.text = value;
                  
              },
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
              TextButton(
                child: const Text('Valider',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                onPressed: () {
                  if(controllerQu.text!=null && !controllerQu.text.isEmpty){
                    actuel.add(pains.last);
                    actuel.last['quantite'] = controllerQu.text;
                    controllerQu.text = '';
                    Navigator.of(context).pop();
                  }else{
                  Fluttertoast.showToast(
                      msg: "Entrer la quantité pain",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );}
                  
                },
              ),
              TextButton(
                child: const Text('Annuler',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                onPressed: () {
                  controllerQu.text = '';
                  if(actuel.length !=0 && actuel.last['quantite'] != 0){
                    Navigator.of(context).pop();
                  }else{
                    Fluttertoast.showToast(
                      msg: "Entrer la quantité pain",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                    
                  }
                },
              ),
            ],

            )
            ],
        ),
      ),
      
    
    );   
  });
  }
}
 /* void saisirLigneCommande(bool modif,Commande com,[var e,var id]) async{
    String _displayStringForOption(Pain option) => option.libele+' '+option.prix;
    // pour la liste déroulante pour les commande
    List<Pain> _userOptions = await futurePains;
    showDialog(context: context, builder: (_){

      return Dialog(
        elevation: 10.0,
        child: SingleChildScrollView(
          padding:EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Title(color: Colors.red, child: Text("Saisir Ligne Commande ",style: TextStyle(color: Colors.red,fontSize: 17,fontWeight: FontWeight.bold),)),
              // pour laa liste déroulante 
              SizedBox(height: 20,),
              Text("Pain :"),
              // pour laa liste déroulante 
              Autocomplete<Pain>(
                displayStringForOption: _displayStringForOption,
                initialValue: controllerP ,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<Pain>.empty();
                  }
                  return _userOptions
                            .where((Pain option) => option.libele.toLowerCase()
                            .toString()
                            .contains(textEditingValue.text.toLowerCase())
                          ).toList();
                },
                
                onSelected: (Pain selection) {
                  // le pain selectionné
                    pain = selection;
                },
                ),
                SizedBox(height: 25),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon:Icon(Icons.production_quantity_limits_outlined),
                    labelStyle: TextStyle(color : Colors.black,fontSize:20),
                    hintText: 'quantite',labelText:'Quantite',
                  ),
                  controller: controllerQu,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Cette valeur ne peut être nulle !!!";
                    }
                  },
                  onSaved: (value) {
                    if (value != null) 
                      controllerQu.text = value;
                      
                  },
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    color: Colors.cyan[900],
                    child: Row(
                      children: [
                        Icon(Icons.add,color:  Colors.white,),
                        Text("Valider",style: TextStyle(color:Colors.white),),
                      ]),
                    onPressed: (){
                      
                      setState(() {
                        quantite = int.parse(controllerQu.text);
                        LigneCommande lcom = LigneCommande(pain,quantite); 
                        servicelignecommande.addLigneCommande(dernierId,lcom);
                      });
                      controllerQu.text ='';
                      //Navigator.pop(context);;
                    },
                  ),
                  MaterialButton(
                    color: Colors.cyan[900],
                    child: Row(
                      children: [
                        Icon(Icons.delete_forever,color: Colors.white,),
                        Text("Terminer",style: TextStyle(color:Colors.white),),
                      ]),
                    onPressed: (){
                      Navigator.pop(context);
                      setState(() {
                        
                      });
                    },
                  ),
                ],),
            ]

        )
      ),
      );
    });
  }


}


class ChildItem extends StatelessWidget {

  final Commande commande;
  late ListeCommande parent;
  final Function notifier;
  
  ServiceCommande service = ServiceCommande();

  ChildItem(this.commande, {required this.notifier});

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      onTap: (){
        //detailClient(name, name.idClient, context);
        detailCom(context);
      },
      title: new Text('Com'+this.commande.idCom.toString()+' par '+ commande.client.prenom+' '+commande.client.nom),
      subtitle: new Text(this.commande.dateL.toString()),
      trailing:Column(
          children: [
            Expanded(
            child: IconButton(
              onPressed: (){
                supprimerCommande(commande,commande.idCom , context);
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

  void detailCom(BuildContext context) {
    Navigator.push(
    context, 
    MaterialPageRoute<void>(
    builder:(BuildContext context) { 
        return DetailCommande(commande: commande);
    }));
                 
  }

  void supprimerCommande(Commande com,int id,BuildContext context){
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title: const Text('Voulez-vous supprimer ?',
        style: TextStyle(color: Colors.deepOrange)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              Text('ID :  Com0'+com.idCom.toString(),),
              SizedBox(height: 10),
              Text('Date Com. :  '+com.date.day.toString()+'-'+com.date.month.toString()+'-'+com.date.year.toString()),
              SizedBox(height: 10),
              Text('Date Liv. :  '+com.dateL.day.toString()+'-'+com.dateL.month.toString()+'-'+com.dateL.year.toString()),
              SizedBox(height: 10),
              Text('Client :  '+com.client.prenom+' '+com.client.nom),
              SizedBox(height: 10),
              Text('Téléphone : '+com.client.telephone),
              SizedBox(height: 10),
              Text('Adresse  : '+com.client.adresse),
              SizedBox(height: 10),
              ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            onPressed: () {
              service.deleteCommande(id);
              Navigator.of(context).pop();
              this.notifier();
              /*
              Fluttertoast.showToast(
                  msg: "Commande supprimé avec succès!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0
              );*/
              
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
  
}*/
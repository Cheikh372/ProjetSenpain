import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:senpain/modeles/client.dart';
import 'package:senpain/modeles/commande.dart';
import 'package:senpain/modeles/pain.dart';
import 'package:senpain/services/serviceClient.dart';
import 'package:senpain/services/serviceCommande.dart';
import 'package:senpain/services/serviceLigneCommande.dart';
import 'package:senpain/services/servicePain.dart';
import '../../modeles/ligneCommande.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailCommande extends StatefulWidget {
  final Commande commande;
  
  DetailCommande({Key? key,required this.commande}) : super(key: key);

  @override
  _DetailCommandeState createState() => _DetailCommandeState(commande);
}
class _DetailCommandeState extends State<DetailCommande> {
  
  Commande com;
  double somS = 0;
  double somRe = 0;

  TextEditingController controllerQu = TextEditingController();
  TextEditingController controllerR = TextEditingController();

  late Future<List<LigneCommande>> futureLigne;

  // les services
  ServiceLigneCommande serviceLigneCommande = ServiceLigneCommande();
  ServicePain serviceP = ServicePain();
  ServiceClient serviceC = ServiceClient();
  ServiceCommande servicecommande = ServiceCommande();

  late Future<List<Pain>> futurePains;
  late Future<List<Client>> futureclients;

  late Pain pain;
  late Client client;
  late DateTime date;
  late List<LigneCommande> l;

  _DetailCommandeState(this.com);

  @override
  void initState(){
    futureLigne = serviceLigneCommande.getLigneCom(com.idCom);
    futureclients = serviceC.getClients();
    futurePains = serviceP.getPains();
    calculMontant();
    setState(() {
    });
    }
  
  // pour les montants de la commande
  void calculMontant() async{
    l = await futureLigne;
    int i ;
    double S=0;
    double R=0;
    double s;

    for(i = 0;i<l.length;i++){
      S = S + l.elementAt(i).quantite*double.parse(l.elementAt(i).pain.prix);
      R = R + l.elementAt(i).retour*double.parse(l.elementAt(i).pain.prix);
    }

    setState(() {
      com.setSommeS(S);
      com.setSommeR(R);
      s = S-R;
      com.setSomme(s);
    });
    
  }

 void  actualiser(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize( 
        preferredSize: Size.fromHeight(80.0),
        child : AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.cyan[900],
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        title: Text(
          " Détail Commande",
          style: TextStyle(color: Colors.white),
          ),
        
      ), 
      ),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          //mainAxisSize: MainAxisSize.max,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text('Lignes de commande :',
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Colors.red,
                ),
              ),
            SizedBox(height: 10),
            Container(
              height: 250,
              child: FutureBuilder<List<LigneCommande>>(
                future: futureLigne,
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return ListView.separated(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) => ListTile(
                      onTap: (){
                        LigneCommande l = snapshot.data![index];
                        setState(() {
                          detailLigne(l);
                        });
                      },
                      title: Text(
                        "${snapshot.data![index].pain.libele} pour ${snapshot.data![index].quantite} unités",
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    subtitle:Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sortie : ${snapshot.data![index].quantite}x${snapshot.data![index].pain.prix} = "+(snapshot.data![index].quantite*int.parse(snapshot.data![index].pain.prix)).toString()),
                        Text("Retour : ${snapshot.data![index].retour}x${snapshot.data![index].pain.prix} = "+(snapshot.data![index].retour*int.parse(snapshot.data![index].pain.prix)).toString()),

                      ],),
                      trailing: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                        child: IconButton(
                          onPressed: (){
                            LigneCommande l = snapshot.data![index];
                            setState(() {
                              supprimerLigne(l);
                            });
                          },
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                            )),
                            ),
                        ],
                      ),
                    ),
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        thickness: 2,
                      );
                    },
                    
                    );
                  }else{
                     return const Center(child: CircularProgressIndicator());
                  }
                  }
                
                ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 2,),
            Text('Total Sortie : ${com.getSommeS()} FCFA',
              style: const TextStyle(
                color: Colors.red,
                ),
              ),
            SizedBox(height: 10),
            Text('Total Retour : ${com.getSommeR()} FCFA',
              style: const TextStyle(
                color: Colors.red,
                ),
              ),
            SizedBox(height: 10),
            Text('Total : ${com.getSomme()} FCFA',
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.normal,
                color: Colors.red,
                ),
              ),
            Divider(height: 10,thickness: 2,),
            SizedBox(height: 10,),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                      MaterialButton(
                        color: Colors.cyan[900],
                        child: Row(
                          children: [
                            Icon(Icons.edit,color: Colors.white,),
                            SizedBox(width: 5,),
                            Text("Modifer",style: TextStyle(color:Colors.white),),
                          ]),
                        onPressed: (){
                          setState(() {
                            modifierCommande(com);
                          });
                        }
                      ),
                      SizedBox(width: 30,),
                      MaterialButton(
                        color: Colors.cyan[900],
                        child: Row(
                          children: [
                            Icon(Icons.backspace_outlined,
                              color: Colors.white,),
                            SizedBox(width: 5,),
                            Text("Fermer",style: TextStyle(color:Colors.white),),
                          ]),
                        onPressed: (){
                          Navigator.of(context).pop();
                        }
                      ),
                    ],
                )
              ],
            )
          ],
        ),
        
        
        
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        onPressed: (){
            setState(() {
              
            });
      }),
    );
  }

  // pour saisir le retour pain d'une ligne de commande
  void detailLigne(LigneCommande l) {
   showDialog(context: context, builder: (_){
          return AlertDialog(
            title: const Text('Détail Ligne Commande',
            style: TextStyle(color: Colors.deepOrange)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  Divider(height: 10,thickness: 2,),
                  Text('ID :  Ligne0'+l.id.toString()),
                  SizedBox(height: 15),
                  Text('Libelé :  '+l.pain.libele),
                  SizedBox(height: 15),
                  Text('Prix unit : '+l.pain.prix),
                  SizedBox(height: 15),
                  Text('Qu. sortie :  '+l.quantite.toString()+'   unités'),
                  SizedBox(height: 15),
                  Text('Qu. retour :  '+l.retour.toString()+'   unités'),
                  Divider(height: 10,thickness: 2,),
                  Text('Montant S. : '+(l.quantite*double.parse(l.pain.prix)).toString()),
                  SizedBox(height: 15),
                  Text('Montant R. :  '+(double.parse(l.pain.prix)*l.retour).toString()),
                  SizedBox(height: 15),
                  Divider(height: 10,thickness: 2,),
                  Text('Total  :    '+((l.quantite)*double.parse(l.pain.prix)-(double.parse(l.pain.prix)*l.retour)).toString(),
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        ),
                        ),
                ],
              ),
            ),
            
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text('Ajout Retour',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    // on afficher le formulaire pour saisir retour pain de cette ligne
                    onPressed: () {
                      setState(() {
                        saisirRetour(l);
                      });
                    },
                  ),
                  TextButton(
                    child: const Text('Modifier',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    // on afficher le formulaire pour modifier
                    onPressed: () {
                      setState(() {
                        modifierLigne(l);
                      });
                    },
                  ),
                  Divider(height: 12,thickness: 12,),
                  TextButton(
                    child: const Text('Fermer',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              
              
            ],
          );   
        });
  }

  void saisirRetour(LigneCommande l) {
    showDialog(context: context, builder: (_){
          return AlertDialog(
            title: const Text('Saisir Retour Pain',
            style: TextStyle(color: Colors.deepOrange)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  Divider(height: 10,thickness: 2,),
                  Text('ID :  Ligne0'+l.id.toString()),
                  SizedBox(height: 15),
                  Text('Libelé :  '+l.pain.libele),
                  SizedBox(height: 15),
                  TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color : Colors.deepOrange,fontSize:20),
                    hintText: 'quantite retour',labelText:'Quantite',
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
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text('Valider',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    
                    onPressed: () {
                      if(controllerQu.text!=null && !controllerQu.text.isEmpty){
                        double q = l.retour + double.parse(controllerQu.text);
                        setState(() {
                          serviceLigneCommande.addRetour(l.id,q);
                        });
                      }else{
                         Fluttertoast.showToast(
                            msg: "Entrer la quantité retour pain",
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
                  SizedBox(width: 15,),
                  TextButton(
                    child: const Text('Annuler',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              
              
            ],
          );   
        });
  }

  void modifierLigne(LigneCommande l) async {
    String _displayStringForOption(Pain option) => option.libele+' '+option.prix;
    // pour la liste déroulante pour les commande
    List<Pain> _userOptions = await futurePains;

    showDialog(context: context, builder: (_){
          return AlertDialog(
            title: const Text('Voulez-vous modifier ?',
            style: TextStyle(color: Colors.deepOrange)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  Text('ID :  Ligne0'+l.id.toString()),
                  SizedBox(height: 15),
                  Text('Libelé :  '+l.pain.libele),
                  Divider(height: 10,thickness: 2,),
                  SizedBox(height: 10),
                  Text('Modifications : ', 
                    style: TextStyle(color: Colors.red,fontSize: 20,),),
                  Autocomplete<Pain>(
                    displayStringForOption: _displayStringForOption,
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
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color : Colors.deepOrange,),
                      hintText: 'Quantite sortie',labelText:'Quantité sortie',
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
                  TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color : Colors.deepOrange,),
                    hintText: 'Quantite retour',labelText:'Quantité retour',
                  ),
                  controller: controllerQu,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Cette valeur ne peut être nulle !!!";
                    }
                  },
                  onSaved: (value) {
                    if (value != null) 
                      controllerR.text = value;   
                  },
                ),  
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text('Valider',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    onPressed: () {
                      LigneCommande ligne = LigneCommande(pain, int.parse(controllerQu.text));
                      ligne.setQuantiteR(double.parse(controllerR.text));
                      setState(() {
                        serviceLigneCommande.modifLigneCommande(ligne,l.id);
                        actualiser();
                      });
                    },
                  ),
                  SizedBox(width: 15,),
                  TextButton(
                    child: const Text('Annuler',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              
              
            ],
          );   
        });
  }

  void supprimerLigne(LigneCommande l) {
    showDialog(context: context, builder: (_){
          return AlertDialog(
            title: const Text('Voulez-vous suppprimer ?',
            style: TextStyle(color: Colors.deepOrange)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  Text('ID :  Ligne0'+l.id.toString()),
                  SizedBox(height: 15),
                  Text('Libelé :  '+l.pain.libele),
                  SizedBox(height: 15),
                  Text('Quantité sortie '+l.quantite.toString()+' unités'),
                  SizedBox(height: 15),
                  Text('Quantité retour '+l.retour.toString()+' unités'),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text('Oui',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    onPressed: () {
                      setState(() {
                        serviceLigneCommande.deleteLigneCommande(l.id);
                      });
                    },
                  ),
                  SizedBox(width: 15,),
                  TextButton(
                    child: const Text('Non',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              
              
            ],
          );   
        });
  }

  void modifierCommande(Commande com) async {
    String _displayStringForOption(Client option) => option.prenom +' '+option.nom+' '+option.telephone;
    // pour la liste déroulante pour les commande
    List<Client> _userOptions = await futureclients;
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title: const Text('Voulez-vous modifier ?',
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: Colors.red,
            )
          ),
        elevation: 10.0,
        content: SingleChildScrollView(
          //padding:EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID :  Com0'+com.idCom.toString(),),
              SizedBox(height: 10),
              Text('Date Com. :  '+com.date.day.toString()+'-'+com.date.month.toString()+'-'+com.date.year.toString()),
              SizedBox(height: 10),
              Text('Date Liv. :  '+com.dateL.day.toString()+'-'+com.dateL.month.toString()+'-'+com.dateL.year.toString()),
              SizedBox(height: 10),
              Text('Client :  '+com.client.prenom+' '+com.client.nom),
              SizedBox(height: 10),
              Text('Modifications :',
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  ),
                ),
              SizedBox(height: 10),
              // pour laa liste déroulante 
              Autocomplete<Client>(
                displayStringForOption: _displayStringForOption,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
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
                  client = selection;
                },
                ),
                SizedBox(height: 20),
                // ici pour la date de livraison 
                DateTimeFormField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    //border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.event_note),
                    labelText: 'Date livraison',
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  //autovalidateMode: AutovalidateMode.always,
                  validator: (e) => (e?.day ?? 0) == 1 ? 'veuillez entrer le jour !' : null,
                  onDateSelected: (DateTime value) {
                    date = value;
                  },
                ),
            ]

        )
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child:Text("Valider",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
              onPressed: (){
                Commande commande = Commande(client,date);
                // permet de d'ajouter une commande 
                setState(() {
                  //servicecommande.modifCommande(commande, com.idCom);
                });   
              },
            ),
            SizedBox(width: 20,),
            TextButton(
              child: Text("Annuler",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],),
      ],
      );
    });
  }
}
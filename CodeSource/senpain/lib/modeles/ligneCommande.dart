
import 'package:senpain/modeles/commande.dart';

import 'pain.dart';

class LigneCommande{
  int id = 0;
  int quantite;
  double retour = 0.0;
  Pain pain;

  double sommeS = 0;
  double sommeR = 0;

  LigneCommande(this.pain,this.quantite);

  Map<String, dynamic> toJson() {
    return {
      "pain": pain.toString(), 
      "quantite": quantite
      };
  }

  @override
  String toString() =>
      'LigneCommande(id:$id,pain: $pain, quantite: $quantite, retour: $retour)';

  LigneCommande.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? json['id'],
        pain = Pain.fromJson(json['pain'] ?? json['pain']),
        quantite = int.parse(json['quantite'] ?? json['quantite']),
        retour = double.parse(json['retour'].toString());

  setQuantiteS(int val){
    this.quantite = val;
  }
  setQuantiteR(double val){
    this.retour = val;
  }

  getQuantiteS(){
    return this.quantite;
  }
  getQuantiteR(){
    return this.retour;
  }

  double get getSommeS => this.sommeS;

 set setSommeS(double sommeS) => this.sommeS = sommeS;

  get getSommeR => this.sommeR;

 set setSommeR( sommeR) => this.sommeR = sommeR;

}
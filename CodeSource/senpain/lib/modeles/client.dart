import 'dart:ui';

class Client{
    int idClient=0;
    String nom;
    String prenom;
    String adresse;
    String telephone;


    Client(this.nom,this.prenom,this.adresse,this.telephone);

    int getId(){
      return idClient;
    }
    void setId(int val){
      this.idClient = val;
    }

    @override
    String toString()=>
            'Client(Id : $idClient,nom: $nom, prenom: $prenom,adresse: $adresse, telephone: $telephone)';
    
    Map<String,dynamic> toJson(){
        return {
            'nom': nom, 
            'prenom': prenom,
            'adresse': adresse,
            'telephone': telephone,
        };
    }

    Client.fromJson(Map<String, dynamic> json)
      : idClient = json['id'] ?? json['id'],
        nom = json['nom'] ?? json['nom'],
        prenom= json['prenom'] ?? json['prenom'],
        adresse = json['adresse'] ?? json['adresse'],
        telephone = json['telephone'] ?? json['telephone'];

    @override
    bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Client && other.nom == nom && other.prenom == prenom;
  }
  
    @override
    int get hashCode => hashValues(prenom, nom);
}

class Employe{
  late int idEmp = 0;
  late String nom;
  late String prenom;
  late String telephone;
  late String adresse;


  Employe(this.nom,this.prenom,this.telephone,this.adresse);

  Map<String, dynamic> toJson() {
    return {"nom": nom, "prenom": prenom,"telephone" : telephone,"adresse" : adresse};
  }

  @override
  String toString() =>
      'Employe(Id: $idEmp,nom: $nom,prenom: $prenom,telephone : $telephone,adresse :$adresse)';

  Employe.fromJson(Map<String, dynamic> json)
      : idEmp = json['id'] ?? json['id'],
        nom = json['nom'] ?? json['nom'],
        prenom= json['prenom'] ?? json['prenom'],
        telephone = json['telephone'] ?? json['telephone'],
        adresse = json['adresse'] ?? json['adresse'];
}
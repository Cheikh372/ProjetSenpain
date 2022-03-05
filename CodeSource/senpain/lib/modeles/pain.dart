import '../services/servicePain.dart';
class Pain {
  int idPain=0;
  String libele;
  String prix;

  Pain(this.libele, this.prix);

  Map<String, dynamic> toJson() {
    return {"libele": libele, "prix": prix};
  }

  @override
  String toString() =>
      'Pain(Id: $idPain, libele: $libele, prix: $prix)';

  Pain.fromJson(Map<String, dynamic> json)
      : idPain = json['id'] ?? json['id'],
        libele = json['libele'] ?? json['libele'],
        prix= json['prix'] ?? json['prix'];
  

  static Future<List<dynamic>?> getSuggestions(String query,List<dynamic> p) async {
    await Future.delayed(Duration(milliseconds: 400), null);
    List<Pain> tagList = <Pain>[];
    ServicePain service = ServicePain();
    tagList = await service.getPains();
    List<dynamic> filteredTagList = <dynamic>[];
   
    for (var tag in tagList) {
      if (tag.libele.toLowerCase().contains(query.toLowerCase())) {
        filteredTagList.add({'name': tag.libele, 'value':tag.idPain ,'qantite' : 0});
      }
    }
    for(var sup in p ){
      filteredTagList.removeWhere((element) => sup['name']==element['name']);
    }
    return filteredTagList;
  }
}
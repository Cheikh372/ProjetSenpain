import 'package:flutter/material.dart';
import '../../menu.dart';
import '../../services/serviceUser.dart';
import '../../modeles/user.dart';

class ListeUser extends StatefulWidget {
  const ListeUser({Key? key}) : super(key: key);

  @override
  _ListeUserState createState() => _ListeUserState();
}

class _ListeUserState extends State<ListeUser> {
  late Future<List<User>> futureUsers;
  ServiceUser service = ServiceUser();

  @override
  void initState() {
    super.initState();
    futureUsers = service.getUsers();
    }
 
  @override
  Widget build(BuildContext context) {
    futureUsers = service.getUsers();
    return Scaffold(
      //drawer: Navbar(),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        title: Text(
          "Les gérants",
          style: TextStyle(color: Colors.white),
          ),
        toolbarHeight: 80,
        backgroundColor: Colors.cyan[900],
      ),  
      // ici le code pour afficher la liste des différents types de pain
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => ListTile(
                leading: CircleAvatar(
                  foregroundColor: Colors.white,
                  radius: 30,
                  child: Text(
                    snapshot.data![index].username[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      ),),
                ),
                title: Text(
                  "${snapshot.data![index].username}",
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(snapshot.data![index].email),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: IconButton(
                          onPressed: () {
                           
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
}

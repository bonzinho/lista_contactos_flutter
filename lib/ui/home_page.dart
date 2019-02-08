import 'dart:io';

import 'package:contact_list/helpers/contact_helper.dart';
import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper(); // singleton só é possivel instanciar uam vez, pois so queremos ter uam base de dados

  List<Contact> contacts = List(); // Lista de Contacts inciiada vazia

  @override
  void initState() {
    super.initState();

    setState(() {
      helper.getAllContacts().then((list){
        contacts = list;
      });
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contactos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
          onPressed: (){},
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: contacts.length,
          itemBuilder: (context, index){
            return _contactCard(context, index);
          }
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index){
    return GestureDetector( // usdo para poder clicar nos cards
      child: Card(
        child: Padding( // usado para poder adicionar u
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Container( // Container usado para poder criar a fotografia redonda
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: contacts[index].img != null ?
                          FileImage(File(contacts[index].img)) :
                            AssetImage("images/default.jpg"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(contacts[index].name ?? "",
                        style: TextStyle(fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(contacts[index].email ?? "",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(contacts[index].phone ?? "",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  )
                ),
              ],
            )
        ),
      ),
    );
  }

}

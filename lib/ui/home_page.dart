import 'dart:io';

import 'package:contact_list/helpers/contact_helper.dart';
import 'package:contact_list/ui/contact_page.dart';
import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

// Constantes
enum OrderOtions {orderaz, orderza}

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
    _getAllContacts();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contactos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOtions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOtions>>[
              const PopupMenuItem<OrderOtions>(
                  child: Text("Ordenar de A-Z"),
                  value: OrderOtions.orderaz,
              ),
              const PopupMenuItem<OrderOtions>(
                  child: Text("Ordenar de Z-A"),
                  value: OrderOtions.orderza,
              ),
            ],
            onSelected: _orderList,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            _showContactPage();
          },
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
      onTap: (){
        _showOptions(context, index);
      },
    );
  }


  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
      context: context,
      builder: (context){
        return BottomSheet(
          onClosing: (){},
          builder: (context){
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min, // vai tentar ocupar o minimo de espaço possivel
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.all(10),
                    child: Text("Ligar",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    onPressed: (){
                      launch("tel:${contacts[index].phone}");
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(10),
                    child: Text("Editar",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    onPressed: (){
                      Navigator.pop(context); // fechar a janela do bottom com os botoes
                      _showContactPage(contact: contacts[index]); // mostra a pagina de editar contacto
                    },
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(10),
                    child: Text("Remover",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    onPressed: (){
                      helper.deleteContact(contacts[index].id);
                      setState(() {
                        contacts.removeAt(index); // romover o item da lista que existe aqui
                        Navigator.pop(context); // fechar a janela do bottom com os botoes
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(context, // grava o registo para poder editar ou criar
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact)) //contact: -> parametro | contact -> valor
    );
    if(recContact != null){
      if(contact != null){
        // estamos a editar um conatcto
        await helper.updateContact(recContact);
      }else{
        // Adicionar um novo
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() async{
     helper.getAllContacts().then((list){
       setState(() {
         contacts = list;
       });
    });
  }

  void _orderList(OrderOtions result){
    switch(result){
      case OrderOtions.orderaz:
        contacts.sort((a,b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOtions.orderza:
        contacts.sort((a,b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }

}

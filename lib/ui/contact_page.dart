import 'dart:io';

import 'package:contact_list/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;

  ContactPage({this.contact}); // construtor que recebe um contacto, o contacto é opcional por isso está dentro de chavetas

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  bool _userEdited = false;
  Contact _editedContact; // contacto que estamos a editar

  // controladores para os campos de texto
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.contact == null){ // widget.contact faz com que consiga aceder à class contactPage em cima
      _editedContact = Contact(); // se não existir contacto para editar significa que vamos criar um novo contacto
    }else{
      _editedContact = Contact.fromMap(widget.contact.toMap());

      // Preencher os campos de texto com os dados do contacto a editar
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editedContact.name ?? "Novo Contacto"), // se existir o nome, ou seja e editar aparece o nome se for um novo contacto aparece "novo contacto"
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){},
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView( // serve para o teclado ficar por cima do conteudo mas poder faer scroll no conteudo
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container( // Container usado para poder criar a fotografia redonda
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _editedContact.img != null ?
                    FileImage(File(_editedContact.img)) :
                    AssetImage("images/default.jpg"),
                  ),
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Nome"),
              controller: _nameController,
              onChanged: (text){
                _userEdited = true; // foi modificado alguam coisa no formulario
                setState(() {
                  _editedContact.name = text; // vai atualizar o titulo da barra
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Email"),
              controller: _emailController,
              onChanged: (text){
                _editedContact.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Telefone"),
              controller: _phoneController,
              onChanged: (text){
                _editedContact.phone = text;
              },
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }
}

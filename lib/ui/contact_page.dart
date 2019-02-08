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

  bool _userEdited = false; // verifica se o utilizador foi editado ou não
  Contact _editedContact; // contacto que estamos a editar

  // controladores para os campos de texto
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode(); // para que o campo nome seja focado

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
    return WillPopScope( // willpopscope chama uma funcção sempre qeu for pedido para dar um pop
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact.name ?? "Novo Contacto"), // se existir o nome, ou seja e editar aparece o nome se for um novo contacto aparece "novo contacto"
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_editedContact.name != null && _editedContact.name.isNotEmpty){
              Navigator.pop(context, _editedContact); // volta para tela anterior e enviapara a tela anterior
            }else{
              FocusScope.of(context).requestFocus(_nameFocus); // Serve para focar o input do nome caso este esteja em branco e tenha sido feito um pedido para inserir novo ocntacto
            }
          },
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
                focusNode: _nameFocus,
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
                  _userEdited = true; // foi modificado alguam coisa no formulario
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Telefone"),
                controller: _phoneController,
                onChanged: (text){
                  _editedContact.phone = text;
                  _userEdited = true; // foi modificado alguam coisa no formulario
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }


  // Função apra mostrar ou não o AlertDialog quando saimos da tela de edição / inserção
  Future<bool> _requestPop(){
    if(_userEdited){ // se exixtiu uma edição mostra um dialogo para o utilizador
      showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Perder alterações?"),
            content: Text("Se sair todas as alterações serão perdidas!"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Continuar"),
                onPressed: (){
                  Navigator.pop(context); // sai do dialogo
                  Navigator.pop(context); // depois de sair do dialogo sai da pagian de contactos
                },
              ),
            ],
          );
        }
      );
      return Future.value(false); // não dixa sair automáticamente da tela
    }else{
      return Future.value(true); // deixa sair da tela
    }
  }

}

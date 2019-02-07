import 'package:contact_list/helpers/contact_helper.dart';
import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper(); // singleton só é possivel instanciar uam vez, pois so queremos ter uam base de dados

  @override
  void initState() {
    super.initState();

    Contact c = Contact();
    c.name = "Vitor Bonzinho";
    c.name = "bonzinho@fe.up.pt";
    c.phone = "938353294";
    c.img = "imgtest";
    helper.saveContact(c);
  }



  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

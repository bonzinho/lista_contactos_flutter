import 'package:contact_list/ui/contact_page.dart';
import 'package:flutter/material.dart';

import 'ui/home_page.dart';

void main(){
  runApp(MaterialApp(
    home: ContactPage(),
    debugShowCheckedModeBanner: false, // retirar a barra a dizer debug
  ));
}
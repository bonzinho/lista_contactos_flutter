import 'package:path/path.dart';
import "package:sqflite/sqflite.dart";

// Nomes das colunas

final String contactTable = 'contactTable';
final String idColumn = 'idColumn';
final String nameColumn = 'nameColumn';
final String emailColumn = 'emailColumn';
final String phoneColumn = 'phoneColumn';
final String imgColumn = 'imgColumn';


// esta classe não pode ter varias instancias por isso e sigleton
class ContactHelper{

  static final ContactHelper _instance = ContactHelper.internal(); // Chamar contrutor interno

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  // declarar Base de dados
  Database _db;

  //incicializar base de dados
  Future<Database> get db async{
    if(_db != null){ // a base de dados já foi inicializada antes
      return _db;
    }else{ // a base de dados ainda não foi inciializada, terá de ser aqui
      _db = await initDb();
      return _db;
    }
  }

  // funcção para inciializar a base de dados
  Future<Database> initDb() async{
    final databasePath = await getDatabasesPath(); //Local onde esta a base de dados
    final path = join(databasePath, "contacts.db"); // Aqui o caminho da base de dados e junto com o o nome da db.

    // abrir a base de dados
    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async{
      await db.execute(
        "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT) "  // vamos pedir para ser criada uam tabela com as colunas
      );
    });
  }

  // Guardar o contacto
  Future<Contact>saveContact(Contact contact) async{
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  // get data dos cotnactos
  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(
        contactTable,
        columns: [idColumn, nameColumn, phoneColumn, emailColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);

    if(maps.length > 0){
      return Contact.fromMap(maps.first); // retorna o primeiro registo
    }else{
      return null; // não encontrou resultados
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact.delete(contactTable, where: "$idColumn = ?", whereArgs: [id]); // retorna um numero
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;
     return await dbContact.update(
         contactTable,
         contact.toMap(),
         where: "$idColumn = ?",
         whereArgs: [contact.id]
     ); // retorna um interio se for com sucesso
  }

  Future<List> getAllContacts() async{
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = List();
    // para cada mapa na lista de mapas trasforma numa lista de contactos
    for(Map m in listMap){
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  Future<int> getNumber() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }

}

// id   name    email       phonr   img
//  0   Vitor   bonzinho@   +351    /images/

class Contact{
  // Classe que vai armazenar todos os dados necessarios para os contactos

  // Atributos
  int id;
  String name;
  String email;
  String phone;
  String img;

  // Serve par armazenar os dados em formato de Map
  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }


  // Função para trasformar os daods do contacto em map para para armazenar
  Map toMap(){
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img,
    };
    // se o id já existir preenche o id, falamos de uma edição, caso não exista esta a criar um novo
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    // Ser para quando o app estiver a ser montado poder ler todos os contactos no print para debug
    return "Contact(id: #id, name: $name, email: $email, phone: $phone, img: $img)";
  }


}
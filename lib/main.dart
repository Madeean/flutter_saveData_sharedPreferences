import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextEditingController nameController = TextEditingController(text: "");
  Future<String>? name;

  Future<void> changeName() async {
    final prefs = await _prefs;
    // final String = prefs.getString('hasil');
    setState(() {
      name = prefs.setString('hasil', nameController.text).then(
        (value) {
          return nameController.text;
        },
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = _prefs.then((value) {
      return (value.getString('hasil') ?? "");
    });
    print(name);
  }

  // nameValue() {
  //   return name;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey,
        title: Text(
          'Simpan data',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.grey,
      body: Container(
        width: double.infinity,
        height: 500,
        decoration: BoxDecoration(
          color: Colors.white60,
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Text('Name'),
                  TextField(
                    controller: nameController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: changeName,
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 50),
                child: Row(
                  children: [
                    name == ""
                        ? Text("isi nama terlebih dahulu")
                        : FutureBuilder(
                            future: name,
                            builder: ((context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              }
                              return Text('Nama Kamu: ${snapshot.data}');
                            }),
                          ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'dart:math';

import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quotes/global.dart';
import 'package:quotes/image.dart';
import 'package:quotes/list.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

Future<void> copyDatabase() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, 'database.db');

  bool fileExists = await databaseExists(path);

  if (!fileExists) {
    ByteData data = await rootBundle.load(join('images/Data.db'));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await copyDatabase();
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, 'database.db');
  Database database = await openDatabase(path);

  list = await database.rawQuery('SELECT * FROM Data');

  for (var row in list) {
    // print(row);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Akaya',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Set<String> categories =
        Set<String>.from(list.map((item) => item['Category']));
    uniqueList = categories.map((category) => {'Category': category}).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Quotes'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 230,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: uniqueList.length,
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height / 4.5,
                            width: MediaQuery.of(context).size.width / 1.05,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  HSLColor.fromAHSL(1.0,
                                          Random().nextDouble() * 360, 0.7, 0.8)
                                      .toColor(),
                                  HSLColor.fromAHSL(1.0,
                                          Random().nextDouble() * 360, 0.7, 0.8)
                                      .toColor()
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                list[index]['Quote'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ImagePage()));
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height / 15,
              width: MediaQuery.of(context).size.width / 1.05,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    HSLColor.fromAHSL(
                            1.0, Random().nextDouble() * 360, 0.5, 0.8)
                        .toColor(),
                    HSLColor.fromAHSL(
                            1.0, Random().nextDouble() * 360, 0.5, 0.8)
                        .toColor()
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Image Quotes',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 530,
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              children: List.generate(
                uniqueList.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListPage(
                                index: index,
                                category: uniqueList[index]['Category'],
                              ),
                            ));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              HSLColor.fromAHSL(1.0,
                                      Random().nextDouble() * 360, 0.5, 0.8)
                                  .toColor(),
                              HSLColor.fromAHSL(1.0,
                                      Random().nextDouble() * 360, 0.5, 0.8)
                                  .toColor()
                            ],
                          ),
                          color: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        child: Text(
                          (uniqueList[index]['Category']),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 33),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}

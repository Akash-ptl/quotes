import 'package:flutter/material.dart';
import 'package:quotes/global.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({
    super.key,
  });

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Image Quotes'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => (list[index]['Image'] != null)
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: NetworkImage(
                                list[index]['Image'],
                              ),
                              fit: BoxFit.cover),
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
                ),
              )
            : null,
      ),
      backgroundColor: Colors.black,
    );
  }
}

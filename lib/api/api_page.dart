import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practice_app/pages/note_list.dart';
import 'detail_page.dart';
import 'model.dart';

class ApiPage extends StatefulWidget {
  const ApiPage({Key? key}) : super(key: key);

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  List<Welcome> welcome = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueAccent,
                title: Center(
                  child: Text("API"),
                ),
              ),
              body: ListView.builder(
                  itemCount: welcome.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(8),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      height: 135,
                      decoration: BoxDecoration(
                        color: Color(0xFF2c3e50),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 54,
                                backgroundImage: NetworkImage("${welcome[index].avatar}"),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name: ${welcome[index].name}",
                                    style: TextStyle(fontSize: 19, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "City: ${welcome[index].city}",
                                    style: TextStyle(fontSize: 19, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Id: ${welcome[index].id}",
                                    style: TextStyle(fontSize: 19, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<List<Welcome>> getData() async {
    final response = await http.get(
      Uri.parse('https://63972eaa86d04c76338d939a.mockapi.io/api_samples'),
    );
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        welcome.add(Welcome.fromJson(index));
      }
      return welcome;
    } else {
      return welcome;
    }
  }
}

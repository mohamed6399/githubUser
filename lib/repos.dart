import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:githubprojet/user_repos.dart';
import 'package:http/http.dart' as http;

class Repo extends StatefulWidget {
  final String username;
  const Repo({super.key, required this.username});

  @override
  State<Repo> createState() => _ReposState();
}

class _ReposState extends State<Repo> {
  List<Repos>? repositorie;

  Future<void> fetchRepos() async {
    final String uri = 'https://api.github.com/users/${widget.username}/repos';
    final response = await http.get(Uri.parse(uri));
    log(response.body);
    log("AZZEEEEE");
    log(uri);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final repoData = jsonData as List;
      repositorie = repoData.map((e) => Repos.fromJson(e)).toList();
      setState(() {});
    } else {
      throw Exception("Erruer lors de l'affichage des repos ");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchRepos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("les repositories d'un utilisateur"),
      ),
      body: repositorie == null
          ? Container(
              child: Center(
                child: Text(
                  "aucun depot",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                fetchRepos();
              },
              child: SizedBox(
                  child: ListView.builder(
                itemCount: repositorie?.length,
                itemBuilder: ((context, index) {
                  var item = repositorie![index];
                  return Column(
                    children: [
                      SizedBox(),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text("projet : "),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  item.name ?? '',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Text(
                                  "liens : ",
                                ),
                                Text(
                                  item.cloneUrl ?? '',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Text("Description : "),
                                Text(
                                  item.description ?? '',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],

                    // title: Text(item.name ?? ''),
                    // // leading: Text(item.owner!.reposUrl ?? ''),
                    // onTap: () {},
                  );
                }),
              )),
            ),
    );
  }
}

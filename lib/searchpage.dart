import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:githubprojet/github_user.dart';
import 'package:githubprojet/repos.dart';
import 'package:http/http.dart' as http;

import 'followers.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchtext = TextEditingController();

  GithubUser? githubUser;
  Future<void> recherche(String terme) async {
    final String uri = 'https://api.github.com/users/${searchtext.text}';
    print(uri);
    final response = await http.get(
      Uri.parse(uri),
    );
    if (response.statusCode == 200) {
      print(response.body);

      setState(() {
        githubUser = GithubUser.fromJson(json.decode(response.body));
      });
    } else {
      throw Exception('Erreur lors de la recherche : ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('rechercher un utilisateur github')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                  controller: searchtext,
                  decoration: InputDecoration(labelText: 'Terme de recherche')),
              SizedBox(
                height: 17,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      String terme = searchtext.text.toString();
                      recherche(terme);
                    },
                    child: Text("search")),
              ),
              SizedBox(
                height: 17,
              ),
              if (githubUser != null) ...[
                SizedBox(
                  height: 120,
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(githubUser!.avatarUrl ?? ''),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Nom :"),
                    Text(githubUser!.name ?? ''),
                  ],
                ),
                SizedBox(
                  height: 13,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Bio :"),
                    Text(githubUser!.bio ?? ''),
                  ],
                ),
                SizedBox(
                  height: 13,
                ),
                SizedBox(
                  height: 13,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Adresse :"),
                    Text(githubUser!.location ?? ''),
                  ],
                ),
              ],
              SizedBox(
                height: 50,
              ),
              if (githubUser != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 105,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Follower(
                                        username: searchtext.text,
                                      )));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("followers"),
                            // Text(githubUser!.followers!.toString()),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 105,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Repo(
                                        username: searchtext.text,
                                      )));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Repos"),
                            // Text(githubUser!.followers!.toString()),
                          ],
                        ),
                      ),
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}

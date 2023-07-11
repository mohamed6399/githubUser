import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:githubprojet/user_followers.dart';
import 'package:githubprojet/searchpage.dart';

class Follower extends StatefulWidget {
  final String username;
  const Follower({super.key, required this.username});

  @override
  State<Follower> createState() => _FollowerState();
}

class _FollowerState extends State<Follower> {
  List<Followers>? followers;

  Future<void> fetchFollowers() async {
    // final String uri = 'https://api.github.com/users/user/followers';
    final String uri =
        'https://api.github.com/users/${widget.username}/followers';

    final response = await http.get(Uri.parse(uri));
    log(response.body);
    log(uri);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final followersData = jsonData as List;
      followers = followersData.map((e) => Followers.fromJson(e)).toList();
      setState(() {});
    } else {
      throw Exception("Erreur lors de l'affichage des suiveurs");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchFollowers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FOLLOWERS"),
      ),
      body: followers == null
          ? Center(child: CircularProgressIndicator())
          : followers!.isEmpty
              ? Container(
                  margin: EdgeInsets.only(top: 35),
                  child: Text(
                    "aucun suiveur",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ))
              : RefreshIndicator(
                  child: SizedBox(
                    child: ListView.builder(
                      itemCount: followers?.length,
                      itemBuilder: (context, index) {
                        var item = followers![index];
                        return ListTile(
                          title: Text(item.login!),
                          //  leading: Text(item.),
                          onTap: () {},
                        );
                      },
                    ),
                  ),
                  onRefresh: () async {
                    fetchFollowers();
                  }),
    );
  }
}

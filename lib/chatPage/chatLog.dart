import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomatoes/Components/userClass.dart';
import 'package:tomatoes/chatPage/chatCart.dart';
import 'dart:developer' as developer;

import 'package:tomatoes/chatPage/chatPage.dart';
import 'package:tomatoes/main.dart';

class chatLog extends StatefulWidget {
  const chatLog({super.key});

  @override
  State<chatLog> createState() => _chatLogState();
}

class _chatLogState extends State<chatLog> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  List<userClass> list = [];
  //storing search item
  List<userClass> _searchList = [];
  bool isSearch = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  isSearch
                      ? SizedBox(
                          height: 1,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My Messages',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 18,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSearch = !isSearch;
                      });
                    },
                    child: isSearch
                        ? Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                    hintText: 'Search',
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(color: Colors.grey),
                                    filled: true,
                                    fillColor: Color(0xFFFFE2DC),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        color: Color(
                                            0xFFF83015), // Set the color for the focused border line
                                        width:
                                            2, // Set the thickness for the focused border line
                                      ),
                                    ),
                                  ),
                                  //when search text changes then updated search list
                                  onChanged: (value) {
                                    _searchList.clear();

                                    for (var i in list) {
                                      if (i.firstName
                                              .toLowerCase()
                                              .contains(value.toLowerCase()) ||
                                          i.lastName
                                              .toLowerCase()
                                              .contains(value.toLowerCase()) ||
                                          i.username
                                              .toLowerCase()
                                              .contains(value.toLowerCase())) {
                                        _searchList.add(i);
                                      }
                                      setState(() {
                                        _searchList;
                                      });
                                    }
                                  },
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isSearch = !isSearch;
                                  });
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Color(0xFFF83015),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.all(15),
                            width: thisSize.width,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFFFE2DC),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Search',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .where('Uid', isNotEqualTo: currentUser.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        //final is to declare a variable that can only be assigned a value once

                        switch (snapshot.connectionState) {
                          //if data is loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );

                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            list = data
                                    ?.map((e) => userClass.fromJson(e.data()))
                                    .toList() ??
                                [];
                            [];
                            if (list.isNotEmpty) {
                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: isSearch
                                      ? _searchList.length
                                      : list.length,
                                  itemBuilder: (context, index) {
                                    return chatCard(
                                        user: isSearch
                                            ? _searchList[index]
                                            : list[index]);
                                  });
                            } else {
                              return Center(
                                  child: Text(
                                'No Connections Found',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ));
                            }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            onPressed: () {},
            child: Icon(
              Icons.add_circle_outline,
              color: Color(0xFFF83015),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomatoes/Components/userClass.dart';
import 'package:tomatoes/chatPage/chatCart.dart';

class chatLog extends StatefulWidget {
  const chatLog({super.key});

  @override
  State<chatLog> createState() => _chatLogState();
}

class _chatLogState extends State<chatLog> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  bool isTextFieldFocused = false;
  List<userClass> list = [];
  final List<userClass> _searchList = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isTextFieldFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                isTextFieldFocused
                    ? const SizedBox(
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
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          hintText: 'Search',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: Colors.grey),
                          filled: true,
                          fillColor: const Color(0xFFFFE2DC),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
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
                    if (isTextFieldFocused)
                      TextButton(
                        onPressed: () {
                          _focusNode.unfocus();
                          _searchList.clear();
                          _searchController.clear();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFFF83015),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(
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
                                physics: const BouncingScrollPhysics(),
                                itemCount: isTextFieldFocused
                                    ? _searchList.length
                                    : list.length,
                                itemBuilder: (context, index) {
                                  return chatCard(
                                      user: isTextFieldFocused
                                          ? _searchList[index]
                                          : list[index]);
                                });
                          } else {
                            return const Center(
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            onPressed: () {},
            child: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFFF83015),
            ),
          ),
        ),
      ),
    );
  }
}

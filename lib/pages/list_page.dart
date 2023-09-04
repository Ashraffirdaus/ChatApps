import 'package:chat_apps_bac/pages/details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  void initState() {
    super.initState();
    // This method is automatically called when the widget is created.

    // Call the function to fetch data from Firestore when this widget is created.
    fetchDataFromFirestore();
  }

  //List of Map
  List<Map<String, dynamic>> employees = [
    // {
    //   "name": "Ashraf",
    //   "department": "Admin",
    // },
    // {
    //   "name": "Ali",
    //   "department": "Marketing",
    // },
    // {
    //   "name": "Abu",
    //   "department": "Sales",
    // }
  ];
  Future<void> fetchDataFromFirestore() async {
    try {
      final currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      setState(() {
        employees = querySnapshot.docs
            .where((doc) =>
                (doc.data() as Map<String, dynamic>)['email'] !=
                currentUserEmail) // Cast doc.data() and use null safety checks
            .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            "email": data['email'],
            "userId": doc.id,
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching data from Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Employee Email List",
        ),
      ),
      body: ListView.builder(
          itemCount: employees.length,
          itemBuilder: ((context, index) {
            return Card(
              child: ListTile(
                title: Text(employees[index]["email"] ??
                    "No Email"), // Display email or "No Email" if it's null
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: ((context) => DetailsPage(
                              recipientUserId: employees[index]["email"],
                            )),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.chevron_right_sharp,
                  ),
                ),
              ),
            );
          })),
    );
  }
}

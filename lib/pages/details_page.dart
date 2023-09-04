import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth for user authentication
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsPage extends StatefulWidget {
  final String recipientUserId; // Add this variable

  const DetailsPage({super.key, required this.recipientUserId});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final TextEditingController messageController = TextEditingController();
  final CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('messages'); // Firestore collection

  void sendMessage() {
    final newMessage = {
      "sender": FirebaseAuth
          .instance.currentUser?.email, // Use current user's email as sender
      "message": messageController.text,
      "time": DateTime.now().toLocal().toString(),
    };

    messagesCollection.add(newMessage);

    setState(() {
      messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Page"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesCollection
                  .where('recipientUserId', isEqualTo: widget.recipientUserId)
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData =
                        messages[index].data() as Map<String, dynamic>;
                    final message = messageData['message'] as String;
                    final sender = messageData['sender'] as String;
                    final time = messageData['time'] as Timestamp;

                    return ListTile(
                      title: Text(message),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sender,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(time.toDate().toString()),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Message",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: sendMessage,
                  child: const Text(
                    "Send",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
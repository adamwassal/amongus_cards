import 'package:amongus_cards/screens/multi/wait.dart';
import 'package:amongus_cards/widgets/bg.dart';
import 'package:amongus_cards/widgets/field.dart';
import 'package:amongus_cards/widgets/logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JoinRoom extends StatefulWidget {
  const JoinRoom({super.key});

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final roomIdController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        starCount: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Logo(),
              const Text("Join Room", style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
        
              Field(
                label: "Your name",
                controller: nameController,
                keyboardType: TextInputType.text,
              ),
              Field(
                label: "Room ID",
                controller: roomIdController,
                keyboardType: TextInputType.text,
              ),
              ElevatedButton(
                onPressed: () {
                  String roomId = roomIdController.text;
                  if (roomId.isNotEmpty) {
                    // Check if the room ID exists in Firestore
                    firestore.collection('rooms').doc(roomId).get().then((doc) {
                      if (doc.exists) {
                        // Add the player to the room
                        List<String> players = List<String>.from(
                          doc.data()!['players'],
                        );
                        players.add(nameController.text);
                        firestore.collection('rooms').doc(roomId).update({
                          'players': players,
                        });
        
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => WaitingPlayers(
                                  roomId: roomId,
                                  player: nameController.text,
                                ),
                          ),
                        );
                      } else {
                        // Show an error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Room ID does not exist")),
                        );
                      }
                    });
                  } else {
                    // Show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a valid Room ID"),
                      ),
                    );
                  }
                },
                child: const Text("Join"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

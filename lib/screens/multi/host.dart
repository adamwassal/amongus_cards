import 'package:amongus_cards/screens/multi/wait.dart';
import 'package:amongus_cards/widgets/bg.dart';
import 'package:amongus_cards/widgets/btn.dart';
import 'package:amongus_cards/widgets/field.dart';
import 'package:amongus_cards/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HostRoom extends StatefulWidget {
  const HostRoom({super.key});

  @override
  State<HostRoom> createState() => _HostRoomState();
}

class _HostRoomState extends State<HostRoom> {
  final name = TextEditingController();
  final playerscount = TextEditingController();
  final killerscount = TextEditingController();
  bool isLoading = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> _addRoom() async {
    try {
      DocumentReference docRef = await firestore.collection('rooms').add({
        'emergency': false,
        'friends': [],
        "friendscount":
            int.parse(playerscount.text) - int.parse(killerscount.text),
        "killers": [],
        "killerscount": int.parse(killerscount.text),
        "owner": name.text,
        "players": [name.text],
        "status":"waiting",
        "startedAt": null,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      print('Error adding document: $e');
      throw e;
    }
  }

  Future<void> _createAndNavigate() async {
    if (!_validateInputs()) return;

    setState(() => isLoading = true);

    try {
      final roomId = await _addRoom();
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => WaitingPlayers(roomId: roomId, player: name.text),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create room: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  bool _validateInputs() {
    if (name.text.isEmpty ||
        playerscount.text.isEmpty ||
        killerscount.text.isEmpty) {
      _showErrorDialog("Please enter all required fields");
      return false;
    }

    final players = int.tryParse(playerscount.text) ?? 0;
    final killers = int.tryParse(killerscount.text) ?? 0;
    final friends = players - killers;

    if (players <= 3) {
      _showErrorDialog("Number of players must be greater than 3");
      return false;
    } else if (killers < 1) {
      _showErrorDialog("Number of killers must be at least 1");
      return false;
    } else if (killers > 3) {
      _showErrorDialog("Number of killers cannot exceed 3");
      return false;
    } else if (killers >= players) {
      _showErrorDialog("Killers must be fewer than total players");
      return false;
    } else if (friends <= killers) {
      _showErrorDialog("Friends must outnumber killers");
      return false;
    }

    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    name.dispose();
    playerscount.dispose();
    killerscount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        starCount: 200,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Logo(),
                const SizedBox(height: 30),
                Field(
                  label: "Your name",
                  controller: name,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20),
                Field(
                  label: "Total players",
                  controller: playerscount,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                Field(
                  label: "Number of killers",
                  controller: killerscount,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 30),
                isLoading
                    ? const CircularProgressIndicator()
                    : Btn(
                      text: "Host Room",
                      function: _createAndNavigate,
                      enabled: true,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

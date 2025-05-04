import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.player, required this.roomId});
  final String player;
  final String roomId;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  String role = 'loading';
  bool isAlive = true;
  List<String> players = [];

  StreamSubscription<DocumentSnapshot>? _playerSub;

  @override
  void initState() {
    super.initState();
    _loadRoleAndStatus();
    _listenToPlayerStatus();
  }

  @override
  void dispose() {
    _playerSub?.cancel();
    super.dispose();
  }

  Future<void> _loadRoleAndStatus() async {
    final storedRole = await _secureStorage.read(key: 'role');
    setState(() {
      role = storedRole ?? 'unknown';
    });

    final doc = await _firestore
        .collection('rooms')
        .doc(widget.roomId)
        .collection('players')
        .doc(widget.player)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        isAlive = data['status'] == 'alive';
      });
    }

    final roomDoc = await _firestore.collection('rooms').doc(widget.roomId).get();
    if (roomDoc.exists) {
      final data = roomDoc.data()!;
      setState(() {
        players = List<String>.from(data['players']);
      });
    }
  }

  void _listenToPlayerStatus() {
    final docRef = _firestore
        .collection('rooms')
        .doc(widget.roomId)
        .collection('players')
        .doc(widget.player);

    _playerSub = docRef.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        setState(() {
          isAlive = data['status'] == 'alive';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    if (role == 'impostor') {
      bgColor = Colors.red.shade900;
    } else if (role == 'crewmate') {
      bgColor = Colors.blue.shade700;
    } else {
      bgColor = Colors.grey.shade800;
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: isAlive
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You are a $role",
                    style: const TextStyle(fontSize: 28, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Game started!",
                    style: TextStyle(fontSize: 22, color: Colors.white70),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Other players:",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  ...players.map(
                    (p) => Text(
                      p,
                      style: TextStyle(
                        fontSize: 16,
                        color: p == widget.player ? Colors.yellow : Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : const Text(
                "You are eliminated!",
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),
      ),
    );
  }
}

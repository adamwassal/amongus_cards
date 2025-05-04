import 'dart:async';
import 'package:amongus_cards/screens/multi/game.dart';
import 'package:amongus_cards/widgets/bg.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WaitingPlayers extends StatefulWidget {
  const WaitingPlayers({super.key, required this.roomId, required this.player});
  final String roomId;
  final String player;

  @override
  State<WaitingPlayers> createState() => _WaitingPlayersState();
}

class _WaitingPlayersState extends State<WaitingPlayers> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late StreamSubscription<DocumentSnapshot> _roomSubscription;

  List<String> players = [];
  bool isHost = false;

  @override
  void initState() {
    super.initState();
    _startListeningToRoom();
  }

  @override
  void dispose() {
    _roomSubscription.cancel();
    super.dispose();
  }

  void _startListeningToRoom() {
    _roomSubscription = _firestore
        .collection('rooms')
        .doc(widget.roomId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          players = List<String>.from(data['players'] ?? []);
          isHost = players.isNotEmpty && players[0] == widget.player;
        });

        // Auto navigate if game has started
        if (data['status'] == 'started') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => GameScreen(
                player: widget.player,
                roomId: widget.roomId,
              ),
            ),
          );
        }
      }
    });
  }

  Future<void> _startGame() async {
    final docRef = _firestore.collection('rooms').doc(widget.roomId);
    final docSnapshot = await docRef.get();
    final data = docSnapshot.data();

    if (data == null || !(data['players'] is List)) {
      return;
    }

    final List<String> playerList = List<String>.from(data['players']);
    if (playerList.length > 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least 4 players are required to start the game')),
      );
      return;
    }

    playerList.shuffle();
    final int impostorCount = (playerList.length / 4).ceil();
    final Map<String, String> roles = {};

    for (int i = 0; i < playerList.length; i++) {
      roles[playerList[i]] = i < impostorCount ? 'impostor' : 'crewmate';
    }

    final batch = _firestore.batch();

    for (final player in playerList) {
      final playerDoc = docRef.collection('players').doc(player);
      batch.set(playerDoc, {
        'role': roles[player],
        'status': 'alive',
      });
    }

    batch.update(docRef, {
      'status': 'started',
      'startedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();

    // Store current player's role securely
    await _secureStorage.write(key: 'player_id', value: widget.player);
    await _secureStorage.write(key: 'role', value: roles[widget.player]);

    // Navigate to GameScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(player: widget.player, roomId: widget.roomId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        starCount: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome, ${widget.player}!",
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              const Text(
                "Waiting for players to join...",
                style: TextStyle(fontSize: 24),
              ),
              Text(
                "Room ID: ${widget.roomId}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              const Text(
                "Players in room:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                children: players
                    .map((player) => Text(
                          player,
                          style: const TextStyle(fontSize: 16),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              if (isHost)
                ElevatedButton(
                  onPressed: _startGame,
                  child: const Text("Start Game"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:game_of_life/board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game of life',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: GameOfLife(title: 'Game of life'),
    );
  }
}

class GameOfLife extends StatelessWidget {
  GameOfLife({super.key, required this.title});
  final String title;

  // Board
  final GlobalKey<BoardState> _boardStateKey = GlobalKey<BoardState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Board(key: _boardStateKey, column: 50, row: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _boardStateKey.currentState?.clearCells(),
                icon: const Icon(Icons.clear),
              ),
              ElevatedButton(
                  onPressed: () => _boardStateKey.currentState?.resetCells(),
                  child: const Text('Reset')),
              ElevatedButton(
                child: Icon(_boardStateKey.currentState?.iconPlayPause),
                onPressed: () => _boardStateKey.currentState?.togglePlayPause(),
              ),
              ElevatedButton(
                  onPressed: () => _boardStateKey.currentState?.updateCells(),
                  child: const Text('Next'))
            ],
          )
        ],
      ),
    );
  }
}

// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'WordPair App',
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final suggestions = <WordPair>[];
  final saved = <WordPair>{};
  final biggerFont = const TextStyle(fontSize: 16);

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('WordPair App'),
          actions: [
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: _pushSaved,
              tooltip: 'Saved Suggestions',
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            if (i.isOdd) return const Divider();

            final index = i ~/ 2;
            if (index >= suggestions.length) {
              suggestions.addAll(generateWordPairs().take(1));
            }

            final alreadySaved = saved.contains(suggestions[index]);
            return buildRow(context, index, alreadySaved);
          },
        ));
  }

  Widget buildRow(BuildContext context, int index, bool alreadySaved) {
    return ListTile(
      title: Text(
        suggestions[index].asPascalCase,
        style: biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.blueAccent : null,
        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            saved.remove(suggestions[index]);
          } else {
            saved.add(suggestions[index]);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: biggerFont,
                ),
              );
            },
          );
        final divided = tiles.isNotEmpty
            ? ListTile.divideTiles(
                context: context,
                tiles: tiles,
            ).toList()
            : <Widget> [];
          
          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white
        )
      ),
      home: const RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
              icon: const Icon(Icons.list),
              onPressed: _pushSaved,
              tooltip: 'Saved Suggestions')
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider();
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          final pairs = generateWordPairs().take(10);
          _suggestions.addAll(pairs);
        }
        final alreadySaved = _saved.contains(_suggestions[index]);

        return _buildRow(_suggestions[index], alreadySaved);
      },
    );
  }

  Widget _buildRow(WordPair pair, alreadySaved) {
    return ListTile(
        title: Text(pair.asPascalCase, style: _biggerFont),
        trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null,
            semanticLabel: alreadySaved ? 'Remove from saved' : 'Save'),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        });
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      final tiles = _saved.map((pair) {
        return ListTile(title: Text(pair.asPascalCase, style: _biggerFont));
      });
      final divided = tiles.isNotEmpty
          ? ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList()
          : <Widget>[];
      return Scaffold(
        appBar: AppBar(
          title: const Text('Saved Suggestions')
        ),
        body: ListView(children: divided,)
      );
    }));
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  RandomWordsState createState() => RandomWordsState();
}

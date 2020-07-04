
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
      theme: ThemeData.dark(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: this._buildSuggestions(),
    );
  }

  void _pushSaved () {
    Navigator.of(this.context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16),
        itemBuilder: (BuildContext context, int i) {
          if (i.isOdd) {
            return Divider();
          }

          final index = i ~/ 2;
          if (index >= this._suggestions.length) {
            this._suggestions.addAll(generateWordPairs().take(10));
          }

          return this._buildRow(this._suggestions[index]);
        }
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = this._saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: this._biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.blue : null,
      ),
      onTap: () {
        this.setState(() => (
            alreadySaved
                ? this._saved.remove(pair)
                : this._saved.add(pair)
        ));
      },
    );
  }
}


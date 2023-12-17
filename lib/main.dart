import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class TextViewsScreen extends StatefulWidget {
  @override
  _TextViewsScreenState createState() => _TextViewsScreenState();
}

class _TextViewsScreenState extends State<TextViewsScreen> {
  Container _buildTextView(String text) {
    return Container(
      width: 58,
      height: 30,
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TextViews in Flutter'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildTextView('...'),
                SizedBox(width: 24),
                _buildTextView('...'),
                SizedBox(width: 24),
                _buildTextView('...'),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _buildTextView('...'),
                SizedBox(width: 24),
                _buildTextView('...'),
                SizedBox(width: 24),
                _buildTextView('...'),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class CharacterData {
  final String name;
  final String server;
  final String guild;
  final String spec;
  final int worldRank;
  final int regionRank;
  final int realmRank;
  final int dpsWorldRank;
  final int dpsRegionRank;
  final int dpsRealmRank;
  final int healWorldRank;
  final int healRegionRank;
  final int healRealmRank;
  final double mythicPlusScore;

  CharacterData({
    required this.name,
    required this.server,
    required this.guild,
    required this.spec,
    required this.worldRank,
    required this.regionRank,
    required this.realmRank,
    required this.dpsWorldRank,
    required this.dpsRegionRank,
    required this.dpsRealmRank,
    required this.healWorldRank,
    required this.healRegionRank,
    required this.healRealmRank,
    required this.mythicPlusScore,
  });
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: YourFlutterWidget(),
    );
  }
}

class YourFlutterWidget extends StatelessWidget {

  final characterTextField = TextEditingController();
  final serverTextField = TextEditingController();

  late CharacterData characterData;

  void fetchData(String characterName, String serverName) async {
    final response = await http.get(Uri.parse(
        'https://raider.io/api/v1/characters/profile?region=us&realm=$serverName&name=$characterName&fields=mythic_plus_scores_by_season%3Acurrent%2Cguild%2Cmythic_plus_ranks'));
    print("fetchData --- response code = " + response.statusCode.toString());
    print("fetchData --- response body = " + response.body);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      // Parse JSON and assign values to characterData properties
      // ...

      characterData = CharacterData(
        name: jsonData['name'],
        server: jsonData['realm'],
        guild: jsonData.containsKey('guild')
            ? jsonData['guild']['name']
            : 'No Guild Listed',
        spec: jsonData['active_spec_name'],
        worldRank: jsonData['mythic_plus_ranks']['overall']['world'],
        regionRank: jsonData['mythic_plus_ranks']['overall']['region'],
        realmRank: jsonData['mythic_plus_ranks']['overall']['realm'],
        dpsWorldRank: jsonData['mythic_plus_ranks']['class_dps']['world'],
        dpsRegionRank: jsonData['mythic_plus_ranks']['class_dps']['region'],
        dpsRealmRank: jsonData['mythic_plus_ranks']['class_dps']['realm'],
        healWorldRank: jsonData['mythic_plus_ranks']['class_healer']['world'],
        healRegionRank: jsonData['mythic_plus_ranks']['class_healer']['region'],
        healRealmRank: jsonData['mythic_plus_ranks']['class_healer']['realm'],
        mythicPlusScore: jsonData['mythic_plus_scores_by_season'][0]['scores']
        ['all']
            .toDouble(),
      );

    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RaiderIO'),
      ),
      body: Directionality(
        textDirection: TextDirection.ltr,
        // Adjust according to your app's direction
        child: Container(
          color: Color(0xFF070707),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Row(
                children: [
                  Image.asset('assets/raiderio_image.png',
                      width: 105, height: 104),
                  SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RaiderIO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Mobile Client',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Enter Character Name:',
                style: TextStyle(
                  color: Color(0xFFE49F24),
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: characterTextField,
                      decoration: InputDecoration(
                        hintText: 'Character',
                        hintStyle: TextStyle(color: Color(0xFF9F9D9D)),
                      ),
                      style: TextStyle(color: Color(0xFF9F9D9D)),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: serverTextField,
                      decoration: InputDecoration(
                        hintText: 'Server',
                        hintStyle: TextStyle(color: Color(0xFF9F9D9D)),
                      ),
                      style: TextStyle(color: Color(0xFF9F9D9D)),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      print("Search button pressed");
                      String characterName = characterTextField.text ;
                      String serverName = serverTextField.text ;
                      fetchData( characterName, serverName);
                      // Perform search action
                    },
                    child: Text('Search'),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      // Clear fields
                    },
                    child: Text('Clear'),
                  ),
                ],
              ),
              // Add more widgets here to replicate your UI
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

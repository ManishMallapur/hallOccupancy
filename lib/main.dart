import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';


void main() {
  runApp(const MyApp());
}

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    required this.channel,
    required this.feeds,
  });

  Channel channel;
  List<Feed> feeds;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    channel: Channel.fromJson(json["channel"]),
    feeds: List<Feed>.from(json["feeds"].map((x) => Feed.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "channel": channel.toJson(),
    "feeds": List<dynamic>.from(feeds.map((x) => x.toJson())),
  };
}

class Channel {
  Channel({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.field1,
    required this.field2,
    required this.field3,
    required this.createdAt,
    required this.updatedAt,
    required this.lastEntryId,
  });

  int id;
  String name;
  String description;
  String latitude;
  String longitude;
  String field1;
  String field2;
  String field3;
  DateTime createdAt;
  DateTime updatedAt;
  int lastEntryId;

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    field1: json["field1"],
    field2: json["field2"],
    field3: json["field3"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    lastEntryId: json["last_entry_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "latitude": latitude,
    "longitude": longitude,
    "field1": field1,
    "field2": field2,
    "field3": field3,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "last_entry_id": lastEntryId,
  };
}

class Feed {
  Feed({
    required this.createdAt,
    required this.entryId,
    required this.field1,
    required this.field2,
    required this.field3,
  });

  DateTime createdAt;
  int entryId;
  String field1;
  String field2;
  String field3;

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
    createdAt: DateTime.parse(json["created_at"]),
    entryId: json["entry_id"],
    field1: json["field1"],
    field2: json["field2"],
    field3: json["field3"],
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "entry_id": entryId,
    "field1": field1,
    "field2": field2,
    "field3": field3,
  };
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hall Occupancy',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Hall Occupancy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
  var resJson;
  var field1var = "--";
  var location = "--";
  var field2var = "--";
  var field3var = "--";
  var field1int;
  var totalcapacity = 130;
  var percent_string = "--";
  var percent = 0.0;
  var percentColor = Colors.green;
  var urlString = 'https://api.thingspeak.com/channels/1653570/feeds.json?results=1';
  final List<String> genderItems = [
    'Dining Hall 2',
    'Indian Coffee House',
  ];

  String? selectedValue;

  final _formKey = GlobalKey<FormState>();

  Future<void> makeGetRequestMess2() async {
    final url = Uri.parse(urlString);
    http.Response response = await http.get(url);
    Welcome welcome = welcomeFromJson(response.body);
    List<Feed> feed = welcome.feeds;
    Channel channel = welcome.channel;
    print('Status code: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');
    print('');

    setState(() {
      field1var = feed[0].field1;
      field2var = feed[0].field2;
      field3var = feed[0].field3;
      field1int = int.parse(field1var);
      if(field1int/totalcapacity <= 0.15){
        percent_string = "15%";
        percent = 0.15;
        percentColor = Colors.green;
      }if(field1int/totalcapacity > 0.15 && field1int/totalcapacity <= 0.30){
        percent_string = "30%";
        percent = 0.30;
        percentColor = Colors.lightGreen;
      }if(field1int/totalcapacity > 0.30 && field1int/totalcapacity <= 0.45){
        percent_string = "45%";
        percent = 0.45;
        percentColor = Colors.yellow;
      }if(field1int/totalcapacity > 0.45 && field1int/totalcapacity <= 0.60){
        percent_string = "60%";
        percent = 0.60;
        percentColor = Colors.orangeAccent as MaterialColor;
      }if(field1int/totalcapacity > 0.60 && field1int/totalcapacity <= 0.75){
        percent_string = "75%";
        percent = 0.75;
        percentColor = Colors.deepOrange;
      }if(field1int/totalcapacity > 0.75){
        percent_string = "90%";
        percent = 0.90;
        percentColor = Colors.red;
      }
      location = channel.name;
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
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 350,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.blueAccent,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.group),
                      title: const Text('Number of People'),
                      subtitle: Text(
                        '$location',
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    Text(
                      'Number of people at $location : $field1var',
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 350,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.blueAccent,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.access_time_outlined),
                      title: const Text('Last Updated'),
                      subtitle: Text(
                        '$location',
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    Text(
                      'Last Update from $location is at $field3var IST',
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 350,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.blueAccent,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.group),
                      title: const Text('Update Frequency'),
                      subtitle: Text(
                        '$location',
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    Text(
                      'Data from $location is updated every $field2var minutes',
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                    ),
                  ],
                ),
              ),
            ),

            const Padding(padding: EdgeInsets.all(20)),

            CircularPercentIndicator(
              animation: true,
              radius: 30.0,
              percent: (percent),
              center: Text(percent_string),
              footer: const Text("Percent Occupied"),
              progressColor: percentColor,
              circularStrokeCap: CircularStrokeCap.round,
            ),

            //(field1var != null ) ? Text("Number of people at $location : $field1var") : const Text(""),
            const Padding(padding: EdgeInsets.all(20)),
            //MaterialButton(onPressed: makeGetRequestMess2, child: const Text("Dining Hall 2"),color: Colors.lightBlueAccent,),
            SizedBox(
              width: 300,
              child: DropdownButtonFormField2(
                decoration: InputDecoration(
                  //Add isDense true and zero Padding.
                  // Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  //Add more decoration as you want here
                  // Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                ),
                isExpanded: true,
                hint: const Text(
                  'Select Location',
                  style: TextStyle(fontSize: 14),
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                ),
                iconSize: 30,
                buttonHeight: 60,
                buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                items: genderItems
                    .map((item) =>
                    DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                    .toList(),
                validator: (value) {
                    if (value == null) {
                    return 'Please select a location';
                  }
                },
                onChanged: (value) {
                  if(value.toString() == "Dining Hall 2"){
                    setState(() {
                      urlString = 'https://api.thingspeak.com/channels/1653570/feeds.json?results=1';
                    });
                    makeGetRequestMess2();
                  }
                  if(value.toString() == "Indian Coffee House"){
                    setState(() {
                      urlString = 'https://api.thingspeak.com/channels/1653570/feeds.json?results=1';
                    });
                    makeGetRequestMess2();
                  }
                },
                onSaved: (value) {
                  selectedValue = value.toString();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

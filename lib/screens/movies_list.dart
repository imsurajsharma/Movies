import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:movies/screens/movies_details.dart';

class MoviesList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MoviesListState();
  }

}

class MoviesListState extends State<MoviesList>{

  final String url= "http://api.themoviedb.org/3/movie/popular?api_key=802b2c4b88ea1183e50e6b285a27696e";
  List data;

  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    this.getData();
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();
      print(_connectionStatus);
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future getData() async {
    http.Response response =
        await http.get(
          Uri.encodeFull(url),
          headers: {"Accept": "application/json"}
        );
    print(response.body);
   
    if (response.statusCode == HttpStatus.ok) {  
        setState(() {
            var convertDataToJson = jsonDecode(response.body);
            data = convertDataToJson['results'];
        }); 
        return data;
    }

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
          children: <Widget>[
            FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var mydata = snapshot.data;
              return new ListView.builder(
          itemCount: mydata == null ? 0 : mydata.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              child: new Center(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Card(
                      child: new ListTile(
                        leading: new Image.network(mydata[index]['backdrop_path']),
                        title: Text(mydata[index]['original_title']),
                        subtitle: Text(mydata[index]['title']),
                        onTap: () {
                Navigator.push(context, new MaterialPageRoute(builder: (__) => new MoviesDetails()));
              },
                      )
                      
                    )
                  ],
                ),
              ),
            );
          },

        );

              
            }
            
            else {
              return Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Loading...",
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ],
              ));
            }

          }
    )
          ],
        )
        );
  }

}

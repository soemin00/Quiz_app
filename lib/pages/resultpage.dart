import 'package:flutter/material.dart';
import 'home.dart';

class ResultPage extends StatefulWidget {
  final int marks;

  ResultPage({required Key key, required this.marks}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<String> images = [
    "assets/images/success.png",
    "assets/images/good.png",
    "assets/images/bad.png",
  ];

  late String message;
  late String image;

  @override
  void initState() {
    if (widget.marks < 20) {
      image = images[2];
      message = "You Should Try Hard..\n" + "You Scored ${widget.marks}";
    } else if (widget.marks < 35) {
      image = images[1];
      message = "You Can Do Better..\n" + "You Scored ${widget.marks}";
    } else {
      image = images[0];
      message = "You Did Very Well..\n" + "You Scored ${widget.marks}";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Material(
              elevation: 10.0,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Material(
                      child: Container(
                        width: 300.0,
                        height: 300.0,
                        child: ClipRect(
                          child: Image(
                            image: AssetImage(image),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 15.0,
                      ),
                      child: Center(
                        child: Text(
                          message,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Quando",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => homepage(), // Adjust the widget name accordingly
                    ));
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    side: BorderSide(width: 3.0, color: Colors.indigo),
                    splashFactory: InkRipple.splashFactory,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

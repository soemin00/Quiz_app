import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_page/pages/resultpage.dart';

class GetJson extends StatefulWidget {
  final String langname;

  GetJson(this.langname);

  @override
  _GetJsonState createState() => _GetJsonState();
}

class _GetJsonState extends State<GetJson> {
  late String assetToLoad;

  // Set the asset to a particular JSON file based on the selected language
  void setAsset() {
    switch (widget.langname) {
      case "Python":
        assetToLoad = "assets/python.json";
        break;
      case "Java":
        assetToLoad = "assets/java.json";
        break;
      case "Javascript":
        assetToLoad = "assets/js.json";
        break;
      case "C++":
        assetToLoad = "assets/cpp.json";
        break;
      default:
        assetToLoad = "assets/linux.json";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Call setAsset to determine the correct asset to load
    setAsset();

    // Use FutureBuilder to load and decode JSON data
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context).loadString(assetToLoad),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display loading indicator while waiting for data
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          // Handle error loading JSON or if data is null
          return Scaffold(
            body: Center(
              child: Text("Error loading data"),
            ),
          );
        } else {
          // Decode JSON data and pass it to QuizPage widget
          List myData = json.decode(snapshot.data!);
          return QuizPage(myData: myData, key: UniqueKey());
        }
      },
    );
  }
}

class QuizPage extends StatefulWidget {
  final List myData;

  QuizPage({required Key key, required this.myData}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Color right = Colors.green;
  Color wrong = Colors.red;
  int marks = 0;
  int currentQuestionIndex = 0;
  int timer = 30;
  String showTimer = "30";
  var randomArray = [];

  Map<String, Color> btnColor = {
    "a": Colors.indigoAccent,
    "b": Colors.indigoAccent,
    "c": Colors.indigoAccent,
    "d": Colors.indigoAccent,
  };

  bool cancelTimer = false;

  @override
  void initState() {
    super.initState();
    genRandomArray();
    startTimer();
  }

  void genRandomArray() {
    var rand = Random();
    while (randomArray.length < 10) {
      int randomNumber = rand.nextInt(widget.myData[1].length) + 1;
      if (!randomArray.contains(randomNumber)) {
        randomArray.add(randomNumber);
      }
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          nextQuestion();
        } else if (cancelTimer) {
          t.cancel();
        } else {
          timer -= 1;
        }
        showTimer = timer.toString();
      });
    });
  }

  void nextQuestion() {
    cancelTimer = false;
    timer = 30;
    setState(() {
      if (currentQuestionIndex < 9) {
        currentQuestionIndex++;
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResultPage(marks: marks, key: UniqueKey()),
        ));

      }
      btnColor.forEach((key, value) {
        btnColor[key] = Colors.indigoAccent;
      });
    });
    startTimer();
  }

  void checkAnswer(String k) {
    if (widget.myData[2][randomArray[currentQuestionIndex].toString()] ==
        widget.myData[1][randomArray[currentQuestionIndex].toString()][k]) {
      marks += 5;
      btnColor[k] = right;
    } else {
      btnColor[k] = wrong;
    }
    setState(() {
      cancelTimer = true;
    });
    Timer(Duration(seconds: 2), nextQuestion);
  }

  Widget choiceButton(String k) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: MaterialButton(
        onPressed: () => checkAnswer(k),
        child: Text(
          widget.myData[1][randomArray[currentQuestionIndex].toString()][k],
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Alike",
            fontSize: 16.0,
          ),
          maxLines: 1,
        ),
        color: btnColor[k],
        splashColor: Colors.indigo[700]!,
        highlightColor: Colors.indigo[700]!,
        minWidth: 200.0,
        height: 45.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return WillPopScope(
      onWillPop: () async {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Quizstar"),
            content: Text("You can't go back at this stage."),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              )
            ],
          ),
        );
        // Always return false to prevent the user from going back
        return false;
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(15.0),
                alignment: Alignment.bottomLeft,
                child: Text(
                  widget.myData[0][randomArray[currentQuestionIndex].toString()],
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Quando",
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: AbsorbPointer(
                absorbing: cancelTimer,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      choiceButton('a'),
                      choiceButton('b'),
                      choiceButton('c'),
                      choiceButton('d'),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                child: Center(
                  child: Text(
                    showTimer,
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


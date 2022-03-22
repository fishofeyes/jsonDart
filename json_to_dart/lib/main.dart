import 'package:any_syntax_highlighter/any_syntax_highlighter.dart';
import 'package:any_syntax_highlighter/themes/any_syntax_highlighter_theme_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_to_dart/convert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Json to dart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  String dartModel = "";
  bool checked = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  void _convert() {
    try {
      String content = _controller.text;
      final res = Convert().convert(
          content: content, className: _controller2.text == "" ? "Response" : _controller2.text, toJson: checked);
      setState(() {
        dartModel = res;
      });
      _copy();
    } catch (e) {
      setState(() {
        dartModel = "json error!";
      });
    }
  }

  void _copy() {
    if (dartModel == "") return;
    Clipboard.setData(ClipboardData(text: dartModel));
    const snackBar = SnackBar(
      content: Text(
        'Copy successfully!',
        style: TextStyle(fontSize: 20),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'JSON to Dart',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Paste your JSON in the textarea below, click convert and get your Dart classes for free.',
                  style: TextStyle(fontSize: 23, color: Colors.black54),
                ),
                const SizedBox(height: 50),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        SizedBox(
                          width: 300,
                          height: 500,
                          child: TextField(
                            controller: _controller,
                            autofocus: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              hintText: "json",
                            ),
                            maxLines: 1000,
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 50,
                          margin: const EdgeInsets.only(top: 16),
                          child: TextField(
                            controller: _controller2,
                            autofocus: true,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                hintText: "dart class name"),
                            maxLines: 1000,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: _convert,
                              child: Container(
                                height: 50,
                                width: 200,
                                margin: const EdgeInsets.only(top: 10),
                                alignment: Alignment.center,
                                decoration:
                                    BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
                                child: const Text(
                                  "Convert to Dart",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Checkbox(
                              value: checked,
                              onChanged: (val) {
                                setState(() {
                                  checked = !checked;
                                });
                              },
                            ),
                            const Text(
                              "toJson",
                              style: TextStyle(fontSize: 17, color: Colors.black),
                            )
                          ],
                        ),
                        CupertinoButton(
                          onPressed: _copy,
                          child: Container(
                            height: 40,
                            width: 300,
                            alignment: Alignment.center,
                            decoration:
                                BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                              "Copy Dart code to clipboard",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: AnySyntaxHighlighter(
                        dartModel,
                        theme: AnySyntaxHighlighterThemeCollection.defaultLightTheme(),
                        isSelectableText: true,
                        textScaleFactor: 1.2,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

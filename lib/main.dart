import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  List<Color> colors = [
    Colors.red,
    Colors.black,
    Colors.blue,
    Colors.pink,
    Colors.brown,
    Colors.amber,
    Colors.indigo,
    Colors.purple,
    Colors.deepOrangeAccent
  ];
  double Font = 5;
  List paints = [];

  Color selectColor = Colors.red;
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            colors.length,
            (index) => Padding(
              padding: const EdgeInsets.all(2.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectColor = colors[index];
                  });
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors[index],
                    border: selectColor == colors[index]
                        ? Border.all(
                            color: Color.fromARGB(255, 18, 0, 216), width: 2)
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ),
        height: 50,
        width: MediaQuery.of(context).size.width - 50,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade500, offset: Offset(1, 1)),
            ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: GestureDetector(
          onPanStart: (details) {
            setState(() {
              paints.add(customItem(
                  offset: details.localPosition,
                  paint: Paint()
                    ..color = selectColor
                    ..strokeWidth = Font));
            });
          },
          onPanUpdate: (details) {
            setState(() {
              paints.add(customItem(
                  offset: details.localPosition,
                  paint: Paint()
                    ..color = selectColor
                    ..strokeWidth = Font));
            });
          },
          onPanEnd: (details) {
            setState(() {
              paints.add(null);
            });
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Stack(
              children: [
                CustomPaint(
                  child: Container(),
                  painter: namePainter(paints: paints),
                ),
                Positioned(
                  top: 20,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 180,
                        child: Slider(
                          activeColor: Color.fromARGB(255, 18, 0, 216),
                          inactiveColor: Colors.grey.shade400,
                          min: 1,
                          max: 50.0,
                          value: Font,
                          onChanged: (value) {
                            setState(() {
                              Font = value;
                            });
                          },
                        ),
                      ),
                      if (paints.isNotEmpty)
                        IconButton(
                            onPressed: () {
                              setState(() {
                                paints.removeLast();
                                paints.removeLast();
                                paints.add(null);
                              });
                            },
                            icon: Icon(Icons.settings_backup_restore_sharp,
                                color: Color.fromARGB(255, 18, 0, 216))),
                      ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                            Colors.white,
                          )),
                          onPressed: () {
                            setState(() {
                              paints.clear();
                            });
                          },
                          label: Text(
                            'Clean Board',
                            style: TextStyle(
                                color: Color.fromARGB(255, 18, 0, 216)),
                          ),
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: Color.fromARGB(
                              255,
                              18,
                              0,
                              216,
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class namePainter extends CustomPainter {
  List paints = [];
  namePainter({required this.paints});
  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < paints.length; i++) {
      if (paints[i] != null && paints[i + 1] != null) {
        canvas.drawLine(
            paints[i].offset, paints[i + 1].offset, paints[i].paint);
      } else if (paints[i] != null && paints[i + 1] == null) {
        canvas.drawPoints(
            PointMode.points, [paints[i].offset], paints[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(namePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(namePainter oldDelegate) => false;
}

class customItem {
  Offset offset;
  Paint paint;
  customItem({required this.offset, required this.paint});
}

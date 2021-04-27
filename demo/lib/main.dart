import 'package:demo/dummy_data.dart';
import 'package:etisalat_task/etisalat_task.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DemoApp(),
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
    );
  }
}

class DemoApp extends StatefulWidget {
  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  List<HelperObj> data = [
    HelperObj(
        cardTitle: 'Moments',
        cardDescription: 'Our happy moments at Etisalat',
        colorCode: Colors.yellow,
        cardIcon: 'assets/camera.png'),
    HelperObj(
        cardTitle: 'E-Appreciate',
        cardDescription: 'Here Recognition Happens',
        colorCode: Colors.orange,
        cardIcon: 'assets/appreciation.png'),
    HelperObj(
        cardTitle: 'Wellbeing',
        cardDescription: 'Our Gateway to Wellness',
        colorCode: Colors.blue,
        cardIcon: 'assets/sun.png'),
    HelperObj(
        cardTitle: 'Surveys',
        cardDescription: 'fill your surveys',
        colorCode: Colors.green,
        cardIcon: 'assets/call-center.png'),
    HelperObj(
        cardTitle: 'Offers',
        cardDescription: 'Our exclusive offers catalogue',
        colorCode: Colors.pink,
        cardIcon: 'assets/discount.png'),
    HelperObj(
        cardTitle: 'Moments',
        cardDescription: 'Our happy moments at Etisalat',
        colorCode: Colors.yellow,
        cardIcon: 'assets/camera.png'),
    HelperObj(
        cardTitle: 'E-Appreciate',
        cardDescription: 'Here Recognition Happens',
        colorCode: Colors.orange,
        cardIcon: 'assets/appreciation.png'),
    HelperObj(
        cardTitle: 'Wellbeing',
        cardDescription: 'Our Gateway to Wellness',
        colorCode: Colors.blue,
        cardIcon: 'assets/sun.png'),
    HelperObj(
        cardTitle: 'Surveys',
        cardDescription: 'fill your surveys',
        colorCode: Colors.green,
        cardIcon: 'assets/call-center.png'),
    HelperObj(
        cardTitle: 'Offers',
        cardDescription: 'Our exclusive offers catalogue',
        colorCode: Colors.pink,
        cardIcon: 'assets/discount.png'),
  ];

  Widget _buildItemList(BuildContext context, int index) {
    if (index == data.length)
      return Center(
        child: CircularProgressIndicator(),
      );
    return Container(
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 250,
                    height: 150,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: data[index].colorCode,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              data[index].cardIcon,
                              width: 100,
                              height: 100,
                            ),
                            Text(
                              '${data[index].cardTitle}',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.black),
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${data[index].cardDescription}',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Horizontal list',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: HorizontalScroll(
              itemBuilder: _buildItemList,
              itemSize: 150,
              dynamicItemSize: true,
              itemCount: data.length,
            )),
          ],
        ),
      ),
    );
  }
}

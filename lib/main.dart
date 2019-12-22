import 'dart:core' as prefix0;
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movies_v2/screens/home_page_2.dart';
import 'package:movies_v2/sevices/custom_scroll.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage2(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = ScrollController();

  final List<int> pages = List.generate(4, (index) => index);

  ScrollPhysics _physics;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.position.haveDimensions && _physics == null) {
        setState(() {
          var dimension =
              _controller.position.maxScrollExtent / (pages.length - 1);
          _physics = CustomScrollPhysics(itemDimension: dimension);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: _controller,
          physics: _physics,
          itemCount: pages.length,
          itemBuilder: (context, index) => Container(
            height: double.infinity,
            width: 300,
            color: randomColor,
            margin: const EdgeInsets.all(10.0),
          ),
        ),
      ),
    );
  }

  Color get randomColor =>
      Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);
}

class MyApp3 extends StatefulWidget {
  @override
  _MyAppState3 createState() => _MyAppState3();
}

class _MyAppState3 extends State<MyApp3> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return TileItem(num: index);
          },
        ),
      ),
    );
  }
}

class TileItem extends StatelessWidget {
  final int num;

  const TileItem({Key key, this.num}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "card$num",
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 485.0 / 384.0,
                  child:
                      Image.network("https://picsum.photos/485/384?image=$num"),
                ),
                Material(
                  child: ListTile(
                    title: Text("Item $num"),
                    subtitle: Text("This is item #$num"),
                  ),
                )
              ],
            ),
            Positioned(
              left: 0.0,
              top: 0.0,
              bottom: 0.0,
              right: 0.0,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return new PageItem(num: num);
                        },
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageItem extends StatelessWidget {
  final int num;

  const PageItem({Key key, this.num}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBar appBar = new AppBar(
      primary: false,
      leading: IconTheme(
          data: IconThemeData(color: Colors.white), child: CloseButton()),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.1),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );

    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Stack(children: <Widget>[
      Hero(
        tag: "card$num",
        child: Material(
          child: Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 485.0 / 384.0,
                child:
                    Image.network("https://picsum.photos/485/384?image=$num"),
              ),
              Material(
                child: ListTile(
                  title: Text("Item $num"),
                  subtitle: Text("This is item #$num"),
                ),
              ),
              Expanded(
                child: Center(child: Text("Some more content goes here!")),
              )
            ],
          ),
        ),
      ),
      Column(
        children: <Widget>[
          Container(
            height: mediaQuery.padding.top,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: appBar.preferredSize.height),
            child: appBar,
          )
        ],
      ),
    ]);
  }
}

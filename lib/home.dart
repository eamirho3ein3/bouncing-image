import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Alignment _startPoint = Alignment.center;
  Alignment _dragAlignment = Alignment.center;

  Animation<Alignment> _animation;

  AnimationController _controller;

  List imageList = [
    'https://keyassets.timeincuk.net/inspirewp/live/wp-content/uploads/sites/8/2015/12/GK10TW-591x400.jpg',
    'https://gfp-2a3tnpzj.stackpathdns.com/wp-content/uploads/2019/10/Collin-M-1-600x600.jpg',
    'https://www.asiapets.in/wp-content/uploads/2021/06/labrador-puppy-for-sale-in-delhi.jpg',
    'https://www.thelabradorsite.com/wp-content/uploads/2018/10/what-is-the-best-age-to-start-training-a-lab-puppy-long.jpg',
    'https://www.anythinglabrador.com/wp-content/uploads/2019/05/How-To-Find-A-Healthy-Labrador-Puppy.jpg'
  ];
  var image = '1';
  Size size;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
    image = imageList[0];
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return GestureDetector(
      onPanEnd: (details) async {
        var reverseX = 1;
        var isReverseX = true;
        var reverseY = 1;
        var isReverseY = true;
        var xStep =
            ((details.velocity.pixelsPerSecond.dx / size.width)) * 0.001;
        var yStep =
            ((details.velocity.pixelsPerSecond.dy / size.height)) * 0.001;
        while (true) {
          _dragAlignment = Alignment(_dragAlignment.x + (xStep * reverseX),
              _dragAlignment.y + (yStep * reverseY));
          await _callAnimation(_startPoint, _dragAlignment);
          _startPoint = _dragAlignment;

          if (_dragAlignment.x > 1 || _dragAlignment.x < -1) {
            if (isReverseX) {
              reverseX = -1;
              isReverseX = false;
            } else {
              reverseX = 1;
              isReverseX = true;
            }
          }

          if (_dragAlignment.y > 1 || _dragAlignment.y < -1) {
            if (isReverseY) {
              reverseY = -1;
              isReverseY = false;
            } else {
              reverseY = 1;
              isReverseY = true;
            }
          }
        }
      },
      child: Align(
        alignment: _dragAlignment,
        child: InkWell(
          onTap: () {
            final _random = new Random();
            setState(() {
              image = imageList[_random.nextInt(imageList.length)];
            });
          },
          child: Container(
            height: 100,
            width: 100,
            color: Colors.red,
            child: Image.network(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  _callAnimation(
    Alignment begin,
    Alignment end,
  ) async {
    _animation = _controller.drive(
      AlignmentTween(
        begin: begin,
        end: end,
      ),
    );

    const spring = SpringDescription(
      mass: 10000,
      stiffness: 1,
      damping: 1,
    );
    final simulation = SpringSimulation(spring, 0, 1, 1000);

    await _controller.animateWith(simulation).whenComplete(() {
      _controller.stop();
    });
  }
}

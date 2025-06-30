import 'package:flutter/material.dart';

class AffectedAreaPage extends StatelessWidget {
  const AffectedAreaPage({super.key});

  void _onAreaTapped(BuildContext context, String area) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$area が選ばれました')),
    );
  }

  @override
    Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: const Color.fromARGB(255, 207, 227, 230),
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                        size: 36,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    'assets/human_outline.png',
                    fit: BoxFit.contain,
                    height: 500,
                  ),
                ),
              Positioned(
              top: 25,
              left: MediaQuery.of(context).size.width / 2 - 152,
              child: GestureDetector(
                onTap: () => _onAreaTapped(context, '顔'),
                child: Container(
                  width: 60,
                  height: 70,
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              top: 25,
              right: MediaQuery.of(context).size.width / 2 -150,
              child: GestureDetector(
                onTap: () => _onAreaTapped(context, '頭'),
                child: Container(
                  width: 60,
                  height: 60,
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              top: 140,
              left: MediaQuery.of(context).size.width / 2 - 220,
              child: GestureDetector(
                onTap: () => _onAreaTapped(context, '右腕'),
                child: Container(
                  width: 40,
                  height: 120,
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              top: 140,
              right: MediaQuery.of(context).size.width / 2 - 215,
              child: GestureDetector(
                onTap: () => _onAreaTapped(context, '右腕'),
                child: Container(
                  width: 40,
                  height: 120,
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              top: 140,
              left: MediaQuery.of(context).size.width / 2 - 70,
              child: GestureDetector(
                onTap: () => _onAreaTapped(context, '左腕'),
                child: Container(
                  width: 40,
                  height: 120,
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              top: 140,
              right: MediaQuery.of(context).size.width / 2 - 70,
              child: GestureDetector(
                onTap: () => _onAreaTapped(context, '左腕'),
                child: Container(
                  width: 40,
                  height: 120,
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              top: 180,
              left: MediaQuery.of(context).size.width / 2 - 162.5,
              child: GestureDetector(
                onTap: () => _onAreaTapped(context, '腹部'),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              top: 280,
              left: MediaQuery.of(context).size.width / 2 - 120,
              child: GestureDetector(
                onTap: () => _onAreaTapped(context, '左足'),
                child: Container(
                  width: 40,
                  height: 180,
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              top: 280,
              right: MediaQuery.of(context).size.width / 2 - 117.5,
              child: GestureDetector(
                onTap: () => _onAreaTapped(context, '左足'),
                child: Container(
                  width: 40,
                  height: 180,
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              top: 280,
              left: MediaQuery.of(context).size.width / 2 - 165,
              child: GestureDetector(
                onTap: () => _onAreaTapped(context, '右足'),
                child: Container(
                  width: 40,
                  height: 180,
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              top: 280,
              right: MediaQuery.of(context).size.width / 2 - 163.5,
              child: GestureDetector(
                onTap: () => _onAreaTapped(context, '右足'),
                child: Container(
                  width: 40,
                  height: 180,
                  color: Colors.transparent,
                ),
              ),
            ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: Container(
              color: Colors.blueGrey,
              child: Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_downward,
                    size: 50,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/DatePage');
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
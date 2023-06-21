import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hfmd_app/widget/spread_screen.dart';
import 'package:hfmd_app/widget/prevention_screen.dart';
import 'package:hfmd_app/widget/treatment_screen.dart';
import 'package:image_card/image_card.dart';
import 'package:hfmd_app/widget/symptoms_screen.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  InfoScreenState createState() => InfoScreenState();
}

class InfoScreenState extends State<InfoScreen> {

  @override
  Widget build(BuildContext context) {

   return Scaffold(
      appBar: AppBar(
        title: Text('Image card demo'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SymptomsScreen(),
                          ),
                        );
                      },
                      child: TransparentImageCard(
                        width: 200,
                        imageProvider: AssetImage('assets/hfmd-info.jpg'),
                        tags: [
                          _tag('Product', () {}),
                        ],
                        title: Text(
                          "Symptoms",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        description: _content(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PreventionScreen(),
                          ),
                        );
                      },
                      child: TransparentImageCard(
                        width: 200,
                        imageProvider: AssetImage('assets/hfmd-info.jpg'),
                        tags: [
                          _tag('Product', () {}),
                        ],
                        title: Text(
                          "Prevention",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        description: _content(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TreatmentScreen(),
                          ),
                        );
                      },
                      child: TransparentImageCard(
                        width: 200,
                        imageProvider: AssetImage('assets/hfmd-info.jpg'),
                        tags: [
                          _tag('Product', () {}),
                        ],
                        title: Text(
                          "Treatment",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        description: _content(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpreadScreen(),
                          ),
                        );
                      },
                      child: TransparentImageCard(
                        width: 200,
                        imageProvider: AssetImage('assets/hfmd-info.jpg'),
                        tags: [
                          _tag('Product', () {}),
                        ],
                        title: Text(
                          "Spread",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        description: _content(color: Colors.white),
                      ),
                    ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            )),
      ),
    );
  }

  Widget _title({Color? color}) {
    return Text(
      'Prevention',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color),
    );
  }

  Widget _content({Color? color}) {
    return Text(
      'This a card description',
      style: TextStyle(color: color),
    );
  }

  Widget _footer({Color? color}) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(
            'assets/hfmd-info.jpg',
          ),
          radius: 12,
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
            child: Text(
          'Super user',
          style: TextStyle(color: color),
        )),
        IconButton(onPressed: () {}, icon: Icon(Icons.share))
      ],
    );
  }

  Widget _tag(String tag, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6), color: Colors.green),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          tag,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}



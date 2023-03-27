import 'package:flutter/material.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});
  @override
  State<StatefulWidget> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('My profile'),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white.withOpacity(0.3),
                    ),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                  SizedBox(width: 8.0),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white.withOpacity(0.3),
                    ),
                    child: Icon(Icons.search, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16.0),
              Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4.0),
                ),
                child: Center(
                  child: Text(
                    'J',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Jerry Zero',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '@jerryzero',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 5.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '1,234',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Followers',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 32.0),
                    Text(
                      '567',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Following',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '1,234',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Followers',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 32.0),
                    Text(
                      '567',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Following',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ]),
            ]));
  }
}

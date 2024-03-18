import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 100),
              Text(
                  'This App is made for storing and managing all the expenses you have done.\n\n'
                      'This App also provides a visual representation of the expenses you have done in the Last 7 days.\n\n'
                      'The Aim of this app is to help the user to spend there money in a more efficient way.\n\n'
                      'Thanks for the using this app , I hope that you will have a better experience.\n\n',
                style: TextStyle(
                  fontSize: 17
                ),

              ),

              SizedBox(height: 150),

              Text(' Developer --> \n'),
              InkWell(
                child: Text('https://www.linkedin.com/in/rishi-raj-32648a196/',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onTap: () => launch('https://www.linkedin.com/in/rishi-raj-32648a196/')
              ),
            ],
          ),
        ),
      ),
    );
  }
}

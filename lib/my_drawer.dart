import 'package:flutter/material.dart';
import 'main.dart';
import 'about.dart';
import 'Monthly.dart';
import 'package:intl/intl.dart';
import 'sql_helper.dart';

class MainDrawer extends StatefulWidget {

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {

  List<Map<String, dynamic>> trans = [];

  void refresh() async {
    final data = await SQLHelper.getItems();
    trans = data ;
  }

  void _deleteTransaction(int id) async {
    await SQLHelper.deleteItem(id);
  }

  void deleteAll() {
    for(int i=0; i<trans.length; i++){
      int idd = trans[i]['id'];
      _deleteTransaction(idd);
    }

    Navigator.of(context, rootNavigator: true).pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );

  }

  void cache(){
    var date = int.parse(DateFormat.d().format(DateTime.now()).toString());
    var late_month = DateTime.now().subtract(Duration(days: date+61));
    for (int i = 0; i < trans.length; i++) {
      if(DateTime.parse(trans[i]['raw_date']).month<=late_month.month){
          int idd = trans[i]['id'];
          _deleteTransaction(idd);
      }

    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );

  }

  void showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 180,
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: Container(
              margin: EdgeInsets.all(15),
              child: Scaffold(
                body: Container(
                  //margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Text('Delete Everything',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                        ),
                      ),
                      Container(
                        child: Text('Are you sure? \n\nTap on Yes to Delete everything you have saved till now.\n'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 90,
                            child: ElevatedButton(
                                onPressed: (){
                                  Navigator.of(context, rootNavigator: true).pop(context);
                                },
                                child: Text('No',
                                style: TextStyle(
                                  fontSize: 24
                                ),
                                ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 90,
                            child: ElevatedButton(
                              onPressed: (){
                                deleteAll();

                              },
                              child: Text('Yes',
                                style: TextStyle(
                                    fontSize: 24
                                ),
                              ),
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    refresh();
    return Drawer(
        child: Container(
          color: Colors.blueGrey.shade50,
          child: SingleChildScrollView(
            child: Column(
              children: [


                Container(
                  height: 200,
                  width: double.infinity,
                  child: Stack(
                    children: [

                      Container(
                          child: Image.asset(
                            'assets/images/1234.jpg',
                            fit: BoxFit.cover,
                          ),
                      ),
                      Container(
                        child: Positioned(
                          bottom : 10,
                          left : 0,
                          child: Container(
                            color: Colors.purpleAccent.shade100.withOpacity(0.5),
                            child: Text('Personal Expenses',
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => monthly()),
                    );
                  },
                  child: Container(
                    height: 60,
                    margin: EdgeInsets.all(5),
                    child: Card(
                      elevation: 0,
                      child: ListTile(
                        leading: Icon(Icons.wallet),
                        title: Text('Monthly Expenses',),
                      ),
                    ),
                  ),
                ),

                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => About()),
                    );
                  },
                  child: Container(
                    height: 60,
                    margin: EdgeInsets.all(5),
                    child: Card(
                      elevation: 0,
                      child: ListTile(
                        leading: Icon(Icons.info),
                        title: Text('About',),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    cache();
                  },
                  child: Container(
                    height: 60,
                    margin: EdgeInsets.all(5),
                    child: Card(
                      elevation: 0,
                      child: ListTile(
                        leading: Icon(Icons.delete_sweep_outlined),
                        title: Text('Clear Cache',),
                      ),
                    ),
                  ),
                ),

                InkWell(
                  onTap: (){
                    showCustomDialog(context);
                  },
                  child: Container(
                    height: 60,
                    margin: EdgeInsets.all(5),
                    child: Card(
                      elevation: 0,
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete All Data',),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
    );
  }
}

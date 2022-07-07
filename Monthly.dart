import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_complete_guide/sql_helper.dart';

class monthly extends StatefulWidget {

  @override
  State<monthly> createState() => monthlyState();
}

class monthlyState extends State<monthly> {

  List<Map<String, dynamic>> trans = [];
  int ct=0;
  double this_month=0;
  double last_month=0;
  double second_last_month=0;

  void _refreshNotes() async {

    final data = await SQLHelper.getItems();
    setState(() {
      ct = 1;
      trans = data ;
    });
  }

  var curr_month = DateTime.now();
  var pastMonth;
  var secMonth;

  void run(){
    int date = int.parse(DateFormat.d().format(DateTime.now()).toString());
    pastMonth = DateTime.now().subtract(Duration(days: date));
    secMonth = DateTime.now().subtract(Duration(days: date+30));
  }


  void get_data() {
    for (int i = 0; i < trans.length; i++) {
          if(DateTime.parse(trans[i]['raw_date']).month==curr_month.month){
            this_month += (trans[i]['price']);
          }
          if(DateTime.parse(trans[i]['raw_date']).month==pastMonth.month){
            last_month += (trans[i]['price']);
          }
          if(DateTime.parse(trans[i]['raw_date']).month==secMonth.month){
            second_last_month += (trans[i]['price']);
          }
    }
  }

  Widget material(DateTime date, double amount, String s){
    return  SizedBox(
      height: 100,
      child: Card(
        margin: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(s),
                  Text(DateFormat.MMMM().format(date).toString(),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Total Expenses'),
                  Text('₹'+(amount.toInt()).toString(),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(ct==0){_refreshNotes();}
    run();
    get_data();
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Expense'),
      ),

      backgroundColor: Colors.blueGrey.shade50,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Last 3 months Expenses',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
             material(curr_month, this_month, 'Current Month'),
              material(pastMonth, last_month, 'Last Month'),
              material(secMonth, second_last_month, 'Second Last Month'),
            ],
        ),
      ),
    );
  }
}

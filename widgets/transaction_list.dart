import 'package:flutter/material.dart';


class TransactionList extends StatefulWidget {
  List<Map<String, dynamic>> transactions = [];
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {

  List<Map<String, dynamic>> get monthlytransactions {
    return widget.transactions.where((tx) {
      return DateTime.parse(tx['raw_date']).isAfter(
        DateTime.now().subtract(
          Duration(days: 30),
        ),
      );
    }).toList();
  }

  double get totalSpending {
    return monthlytransactions.fold(0, (sum, item) {
      return sum + item['price'];
    });
  }

  List<Map<String, dynamic>> data = [];

  void refresh(String s){
    if(s=='sort by date'){
      List<Map<String, dynamic>> temp = List.of(monthlytransactions);
      temp.sort((a, b) {return DateTime.parse(b['raw_date']).compareTo(DateTime.parse(a['raw_date']));});
      data = temp;
    }
    else{
      List<Map<String, dynamic>> temp = List.of(monthlytransactions);
      temp.sort((a, b) {return (b['price']).compareTo(a['price']);});
      data = temp;
    }
  }

  String dropdownvalue = 'sort by date';

  Widget dropdown() {
    return DropdownButton<String>(
      isExpanded: false,
      value: dropdownvalue,
      elevation: 16,
      style: const TextStyle(color: Colors.blueGrey),
      underline: Container(
        height: 2,
        color: Colors.blueGrey,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownvalue = newValue;
          refresh(dropdownvalue);
        });
      },
      items: <String>['sort by date', 'sort by amount']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }



  @override
  Widget build(BuildContext context) {
    refresh(dropdownvalue);
    return Container(
      height: 600,
      child: monthlytransactions.isEmpty
          ? Column(
              children: <Widget>[
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: 200,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    )),
              ],
            )
          : Container(
            child: Column(
              children: [
                Center(
                  child: Container(
                    //height: 30,
                    margin: EdgeInsets.only(top: 17),
                    child: Text(
                      'Total Expenses in Last 30 Days :    ₹${totalSpending.toInt()}',
                      style: TextStyle(
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      dropdown(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 500,
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      return Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 5,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: FittedBox(
                                child: Text(
                                    '\₹${data[index]['price'].toInt()}'),
                              ),
                            ),
                          ),
                          title: Text(
                            data[index]['title'],
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(
                            data[index]['view_date'],
                            //DateFormat.yMMMd().format(transactions[index]['date']),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () => widget
                                .deleteTx(data[index]['id']),
                          ),
                        ),
                      );
                    },
                    itemCount: monthlytransactions.length,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

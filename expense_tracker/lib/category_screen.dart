import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sqflite/sqflite.dart';
import 'ExpenseTracker_Database.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'main.dart';

class CategoryView extends StatefulWidget {
  final String category;
  const CategoryView({super.key, required this.category});

  @override
  _CategoryViewState createState() => _CategoryViewState(category);
}

class _CategoryViewState extends State<CategoryView> {
  final String category;
  _CategoryViewState(this.category);

  TextEditingController budgetController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  double total = 0;
  static double budget = 500;
  double percentage = 0;
  Color overBudget = Colors.blue;

  @override
  void dispose() {
    super.dispose();
    budgetController.dispose();
    itemController.dispose();
    amountController.dispose();
  }

  List<Map<String, dynamic>> _expenses = [];

  //refreshes state of table
  void _refreshExpenses() async {
    final data = await DatabaseHelper.getItems();
    setState(() {
      _expenses = data;
      _calculateTotal();
    });
    _setGoal();
  }

  Future<void> _calculateTotal() async {
    total = (await DatabaseHelper.calculateTotal(category))[0]['TOTAL'] ?? 0;
  }

  //set the remaining budget value
  Future<void> _setGoal() async {
    budget = (await DatabaseHelper.getBudget())[0][category] ?? 500;
    setState(() {
      budget;
    });
    if (total == 0) {
      setState(() {
        percentage = 0;
      });
    } else if (total > budget) {
      setState(() {
        percentage = 1;
        overBudget = Colors.red;
      });
    } else {
      setState(() {
        percentage = (total / budget);
        overBudget = Colors.blue;
      });
    }
  }

  Future<void> _updateBudget() async {
    await DatabaseHelper.updateBudget(double.parse(budgetController.text));
    _setGoal();
  }

  //Creates table
  @override
  void initState() {
    super.initState();
    DatabaseHelper.setCategory(category);
    DatabaseHelper.initBudget();
    _calculateTotal();
    _refreshExpenses();
  }

  //create
  Future<void> _addItem() async {
    await DatabaseHelper.createItem(
        itemController.text, double.parse(amountController.text));
    _refreshExpenses();
  }

  //update
  Future<void> _updateItem(int id) async {
    await DatabaseHelper.updateItem(
        id, itemController.text, double.parse(amountController.text));
    _refreshExpenses();
  }

  //delete
  Future<void> _deleteItem(int id) async {
    await DatabaseHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted an expense'),
    ));
    _refreshExpenses();
  }

  //UI for inputting data into table
  void _showForm(int? id) async {
    //If id is created already, allow update/delete
    if (id != null) {
      final existingExpenses =
          _expenses.firstWhere((element) => element['id'] == id);
      itemController.text = existingExpenses['item'];
      amountController.text = existingExpenses['amount'].toString();
    }

    //Shows screen to input expense details
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 80,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    maxLines: null,
                    controller: itemController,
                    decoration: const InputDecoration(
                        hintText: 'Item',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(
                        hintText: 'Amount',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (id == null) {
                        await _addItem();
                      }
                      if (id != null) {
                        await _updateItem(id);
                      }

                      itemController.text = '';
                      amountController.text = '';

                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Add new' : 'Update'),
                  )
                ],
              ),
            ));
  }

  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    _refreshExpenses();
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text('$category'),
        backgroundColor: Colors.purple, //Add $category to display category
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 200,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'Total: \$$total',
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Budget Goal',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
                LinearPercentIndicator(
                  animation: true,
                  animationDuration: 2000,
                  percent: percentage,
                  center: (Text('\$$total/\$$budget')),
                  barRadius: const Radius.circular(20),
                  lineHeight: 30,
                  progressColor: overBudget,
                ),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                TextField(
                                  maxLines: null,
                                  controller: budgetController,
                                  decoration: const InputDecoration(
                                      hintText: 'Enter Budget Here',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      )),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _updateBudget();
                                    budgetController.text = '';
                                    Navigator.pop(context);
                                  },
                                  child: Text('Submit'),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: const Text('Edit Budget'),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _expenses.length,
                    itemBuilder: (context, index) => Card(
                          color: Colors.green,
                          margin: const EdgeInsets.all(5),
                          child: ListTile(
                              title: Text(_expenses[index]['item']),
                              subtitle: Text('\$${_expenses[index]['amount']}'),
                              trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () =>
                                            _showForm(_expenses[index]['id']),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () =>
                                            _deleteItem(_expenses[index]['id']),
                                      )
                                    ],
                                  ))),
                        ))
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}

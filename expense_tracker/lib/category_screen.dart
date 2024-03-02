import 'package:flutter/material.dart';
import 'main.dart';
import 'database_helper.dart';

class CategoryView extends StatefulWidget {
  final String category;
  const CategoryView({super.key, required this.category});

  @override
  _CategoryViewState createState() => _CategoryViewState(category);
}

class _CategoryViewState extends State<CategoryView> {
  final String category;
  _CategoryViewState(this.category);

  TextEditingController itemController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    itemController.dispose();
    amountController.dispose();
  }

  List<Map<String, dynamic>> _expenses = [];

  //refreshes state of table
  void _refreshExpenses() async {
    final data = await DatabaseHelper.getItems(category);
    setState(() {
      _expenses = data;
    });
  }

  //Creates table
  @override
  void initState() {
    super.initState();
    _refreshExpenses();
    print("..number of items ${_expenses.length}");
  }

  //create
  Future<void> _addItem() async {
    await DatabaseHelper.createItem(
        category, itemController.text, double.parse(amountController.text));
    _refreshExpenses();
  }

  //update
  Future<void> _updateItem(int id) async {
    await DatabaseHelper.updateItem(
        category, id, itemController.text, double.parse(amountController.text));
    _refreshExpenses();
  }

  //delete
  Future<void> _deleteItem(int id) async {
    await DatabaseHelper.deleteItem(category, id);
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
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('$category'),
        backgroundColor: Colors.purple, //Add $category to display category
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _expenses.length,
                  itemBuilder: (context, index) => Card(
                        color: Colors.green,
                        margin: const EdgeInsets.all(5),
                        child: ListTile(
                            title: Text(_expenses[index]['item']),
                            subtitle: Text(
                                '\$' + _expenses[index]['amount'].toString()),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}

class CategoryList {
  CategoryList(this.category, this.percentage);
  final String category;
  final int percentage;
}

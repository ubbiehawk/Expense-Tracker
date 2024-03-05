import 'package:expense_tracker/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'database_helper.dart';
import 'category_screen.dart';
// Import your CategoryView widget if it's defined in a separate file.

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<CategoryList> _chartData;
  late TooltipBehavior _tooltipBehavior;
  late TextEditingController _textFieldController = TextEditingController();
  late SelectionBehavior _selectionBehavior;
<<<<<<< HEAD
  late int _counter = 0;
=======
  late int _counter= 0;

>>>>>>> e678d83c3e49a754ddfaccba718c91d023c64b73

  @override
  void initState() {
    _chartData = getInitialChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _selectionBehavior = SelectionBehavior(enable: true);
    //_getSumTotal();
    super.initState();
  }

  double total = 0;
  double sumTotal = 0;

  Future<double> _calculateTotal(String category) async {
    total = (await DatabaseHelper.calculateTotal(category))[0]['TOTAL'];
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
<<<<<<< HEAD
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
                  'Total $sumTotal',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
=======
        
>>>>>>> e678d83c3e49a754ddfaccba718c91d023c64b73
            Expanded(
              child: SfCircularChart(
                onDataLabelTapped: (onTapArgs) {
                  String tappedCategory =
                      _chartData[onTapArgs.pointIndex].category;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CategoryView(category: tappedCategory),
                    ),
                  );
                },
<<<<<<< HEAD
                onLegendTapped: (legendTapArgs) {
                  List<String> categories =
                      _chartData.map((category) => category.category).toList();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Categories'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            categories.length,
                            (index) => ListTile(
                              title: Text(categories[index]),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        // Handle edit button tap
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          _chartData.removeAt(index);

                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
=======
>>>>>>> e678d83c3e49a754ddfaccba718c91d023c64b73
                title: ChartTitle(text: 'Expense Tracker'),
                legend: Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                tooltipBehavior: _tooltipBehavior,
                selectionGesture: ActivationMode.singleTap,
                series: <CircularSeries>[
                  PieSeries<CategoryList, String>(
                    dataSource: _chartData,
                    xValueMapper: (CategoryList data, _) => data.category,
                    yValueMapper: (CategoryList data, _) => data.percentage,
                    enableTooltip: true,
                    dataLabelMapper: (CategoryList data, _) => data.category,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  )
                ],
              ),
            ),
<<<<<<< HEAD
            Text(
              " Total Amount: \$${calculateTotalPercentage()}",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 70,
            ),
            Text(
              "Monthly Goals:\$$_counter",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Slider(
              min: 0,
              max: 10000,
              value: _counter.toDouble(),
              onChanged: (double value) {
                setState(() {
                  _counter = value.toInt();
                });
              },
              activeColor: Colors.blue,
              inactiveColor: Colors.red,
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (_) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextField(
                                  controller: _textFieldController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter category',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    addCategory();
                                    Navigator.pop(context);
                                  },
                                  child: Text('Add Category'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
=======
            Text( " Total Amount: \$${calculateTotalPercentage()}", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), ),
            SizedBox(height: 70,),
            Text( "Monthly Goals:\$$_counter", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            Slider(
              min: 0,
max: 10000,
value: _counter.toDouble(),
onChanged: (double value) {
setState(() {
_counter = value.toInt();
});
},
activeColor: Colors.blue,
inactiveColor: Colors.red,
            ),
            Row(
              children: [
            ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (_) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _textFieldController,
                              decoration: InputDecoration(
                                hintText: 'Enter category',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                addCategory();
                                Navigator.pop(context);
                              },
                              child: Text('Add Category'),
                            ),
                          ],
                        ),
                      ),
>>>>>>> e678d83c3e49a754ddfaccba718c91d023c64b73
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add Category'),
                ),
                SizedBox(
                  width: 100,
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Categories'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              _chartData.length,
                              (index) => ListTile(
                                title: Text(_chartData[index].category),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          // Show AlertDialog for editing category name
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              // Create a TextEditingController for the AlertDialog
                                              TextEditingController
                                                  editingController =
                                                  TextEditingController(
                                                      text: _chartData[index]
                                                          .category);

                                              return AlertDialog(
                                                title: Text('Edit Category'),
                                                content: TextField(
                                                  controller: editingController,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Enter new category name',
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _chartData[index]
                                                                .category =
                                                            editingController
                                                                .text;
                                                      });
                                                      // Clear the editing controller and close the dialog
                                                      editingController.clear();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('Save'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      editCategory(
                                                          editingController
                                                              as String,
                                                          index);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            _chartData.removeAt(index);
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text("Update / Delete"),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(width: 100,),
         ElevatedButton(
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Categories'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              _chartData.length,
              (index) => ListTile(
                title: Text(_chartData[index].category),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                    IconButton(
  icon: const Icon(Icons.edit),
  onPressed: () {
    // Show AlertDialog for editing category name
    showDialog(
      context: context,
      builder: (context) {
        // Create a TextEditingController for the AlertDialog
        TextEditingController editingController =
            TextEditingController(text: _chartData[index].category);

        return AlertDialog(
          title: Text('Edit Category'),
          content: TextField(
            controller: editingController, 
            decoration: InputDecoration(
              hintText: 'Enter new category name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
               
                setState(() {
                  _chartData[index].category = editingController.text;
                });
                // Clear the editing controller and close the dialog
                editingController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
               editCategory(editingController as String, index);
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  },
),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _chartData.removeAt(index);
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                
                ),
                
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  },
  child: Text("Update / Delete"),
),
              ],
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  List<CategoryList> getInitialChartData() {

    final List<CategoryList> chartData = [
      CategoryList('Home', 16667),
<<<<<<< HEAD
      CategoryList('Auto', 16667),
=======
      CategoryList('Auto',16667),
>>>>>>> e678d83c3e49a754ddfaccba718c91d023c64b73
      CategoryList('Grocery', 16667),
      CategoryList('Savings', 16667),
      CategoryList('Entertainment', 16667),
      CategoryList('Bills', 16667),
    ];
    return chartData;
  }

  void addCategory() {
    setState(() {
      String newCategory = _textFieldController.text;
      if (newCategory.isNotEmpty) {
        _chartData.add(CategoryList(newCategory, 16667));
        _textFieldController.clear();
      }
    });
  }

<<<<<<< HEAD
  void editCategory(String editCategory, int index) {
=======
    void editCategory(String editCategory, int index) {
>>>>>>> e678d83c3e49a754ddfaccba718c91d023c64b73
    setState(() {
      if (editCategory.isNotEmpty) {
        _chartData[index].category = editCategory;
        _textFieldController.clear();
      }
    });
  }
<<<<<<< HEAD

=======
>>>>>>> e678d83c3e49a754ddfaccba718c91d023c64b73
  int calculateTotalPercentage() {
    int total = 0;
    for (var category in _chartData) {
      total += category.percentage;
    }
    return total;
  }
}


class CategoryList {
  CategoryList(this.category, this.percentage);
  String category;
  final int percentage;
}

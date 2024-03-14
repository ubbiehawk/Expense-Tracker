import 'package:expense_tracker/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'ExpenseTracker_Database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  final TextEditingController _textFieldController = TextEditingController();
  //late SelectionBehavior _selectionBehavior;
  late int _counter = 0;

  @override
  void initState() {
    _chartData = getInitialChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    //_selectionBehavior = SelectionBehavior(enable: true);
    super.initState();
    _refreshChart();
  }

  void _refreshChart() {
    setState(() {
      _calculateTotals();
    });
  }

  Future<void> _calculateTotals() async {
    for (var total in _chartData) {
      total.percentage =
          (await DatabaseHelper.calculateTotal(total.category))[0]['TOTAL'] ??
              0;
      if (total.percentage == 0) {
        total.isEmpty = true;
        total.percentage = 100;
      } else if (total.percentage != 0) {
        total.isEmpty = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _refreshChart();
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(75, 16, 0, 0),
              child: Row(
                children: [
                  Text(
                    "Monthly Goals:\$$_counter",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  IconButton(
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
                                    decoration: const InputDecoration(
                                      hintText: 'Edit Monthly Goal ',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      _counter =
                                          int.parse(_textFieldController.text);

                                      Navigator.pop(context);
                                    },
                                    child: const Text('Edit Goal'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  )
                ],
              ),
            ),
            Slider(
              min: 0,
              max: 20000,
              value: _counter.toDouble(),
              onChanged: (double value) {
                setState(() {
                  _counter = value.toInt();
                });
              },
              activeColor: Colors.blue,
              secondaryActiveColor: Colors.green,
              inactiveColor: Colors.red,
            ),
            Expanded(
              child: SfCircularChart(
                onDataLabelTapped: (onTapArgs) {
                  String tappedCategory =
                      _chartData[onTapArgs.pointIndex].category;
                  //Navigate to categories
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CategoryView(category: tappedCategory),
                    ),
                  );
                  setState(() {
                    _refreshChart();
                  });
                },
                // title: ChartTitle(text: 'Expense Tracker'),

                legend: const Legend(
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
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  )
                ],
              ),
            ),
            Text(
              " Total Amount: \$${calculateTotalPercentage()}",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 70,
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
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextField(
                                  controller: _textFieldController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter category',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    addCategory();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Add Category'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Category'),
                ),
                const SizedBox(
                  width: 80,
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Categories'),
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
                                                title:
                                                    const Text('Edit Category'),
                                                content: TextField(
                                                  controller: editingController,
                                                  decoration:
                                                      const InputDecoration(
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
                                                    child: const Text('Save'),
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
                                                    child: const Text('Cancel'),
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
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text("Update / Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<CategoryList> getInitialChartData() {
    final List<CategoryList> chartData = [
      CategoryList('Home', 100, true),
      CategoryList('Auto', 100, true),
      CategoryList('Bills', 100, true),
      CategoryList('Grocery', 100, true),
      CategoryList('Savings', 100, true),
      CategoryList('Entertainment', 100, true),
    ];
    return chartData;
  }

  void addCategory() {
    setState(() {
      String newCategory = _textFieldController.text;
      if (newCategory.isNotEmpty) {
        _chartData.add(CategoryList(newCategory, 100, true));
        _textFieldController.clear();
      }
    });
  }

  void editCategory(String editCategory, int index) {
    setState(() {
      if (editCategory.isNotEmpty) {
        _chartData[index].category = editCategory;
        _textFieldController.clear();
      }
    });
  }

  double calculateTotalPercentage() {
    double total = 0;
    for (var category in _chartData) {
      if (category.isEmpty == false) {
        total += category.percentage;
      }
    }
    return total;
  }
}

class CategoryList {
  CategoryList(this.category, this.percentage, this.isEmpty);
  String category;
  double percentage;
  bool isEmpty;
}

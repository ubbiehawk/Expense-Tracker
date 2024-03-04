import 'package:expense_tracker/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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

  @override
  void initState() {
    _chartData = getInitialChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _selectionBehavior = SelectionBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
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
                            SizedBox(height: 12),
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
                );
              },
              icon: Icon(Icons.add),
              label: Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }

  List<CategoryList> getInitialChartData() {
    final List<CategoryList> chartData = [
      CategoryList('Home', 11600),
      CategoryList('Auto', 12490),
      CategoryList('Grocery', 12900),
      CategoryList('Savings', 23050),
      CategoryList('Entertainment', 24880),
      CategoryList('Bills', 34390),
    ];
    return chartData;
  }

  void addCategory() {
    setState(() {
      String newCategory = _textFieldController.text;
      if (newCategory.isNotEmpty) {
        _chartData.add(CategoryList(newCategory, 12500));
        _textFieldController.clear();
      }
    });
  }
}

class CategoryList {
  CategoryList(this.category, this.percentage);
  final String category;
  final int percentage;
}


/*
class CategoryDetailPage extends StatelessWidget {
  final String category;

  const CategoryDetailPage({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Detail: $category'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => addExpenseView(category: category)));
            },
          ),
        ],
      ),
    );
  }
}
*/
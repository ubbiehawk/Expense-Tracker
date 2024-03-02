import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'category_screen.dart';

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
                //Clicking on Data Labels will send you to a new page
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
                //Pie Chart Creation
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
                    //Sets Data Labels as the Category Names
                    dataLabelMapper: (CategoryList data, _) => data.category,
                    dataLabelSettings: DataLabelSettings(isVisible: true),

                    //  selectionBehavior: _selectionBehavior,
                  )
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                addCategory();
              },
              icon: Icon(Icons.add),
              label: Text('Add Category'),
            ),
            TextField(
              controller: _textFieldController,
              decoration: InputDecoration(labelText: "New Category"),
            ),
          ],
        ),
      ),
    );
  }

//Inital Categories *IGNORE NUMBERS***
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

//Adds a Category to the chart if Text-Field isn't Empty
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
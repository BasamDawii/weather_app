

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;

import 'data_source.dart';
import 'models/time_series.dart';

final List<Color> seriesColors = [Colors.red, Colors.green, Colors.blue, Colors.orange]; // Example colors


class ChartScreen extends StatefulWidget {
const ChartScreen({Key? key}) : super(key: key);

@override
_ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
Future<WeatherChartData>? chartData;

@override
void initState() {
super.initState();
chartData = loadChartData();
}

Future<WeatherChartData> loadChartData() {
// Fetch chart data using the DataSource provider
return context.read<DataSource>().getChartData();
}

Future<void> _onRefresh() async {
setState(() {
chartData = loadChartData();
});
}

@override
Widget build(BuildContext context) {
return Scaffold(
body: SafeArea(
child: RefreshIndicator(
onRefresh: _onRefresh,
child: FutureBuilder<WeatherChartData>(
future: chartData,
builder: (context, snapshot) {
if (!snapshot.hasData) return const CircularProgressIndicator();
final variables = snapshot.data!.daily!;
return Column(
children:[
Expanded(
child: Padding(
padding: const EdgeInsets.all(15.0),
child: charts.TimeSeriesChart(
[
for (final variable in variables)
charts.Series<TimeSeriesDatum, DateTime>(
id: '${variable.name} ${variable.unit}',
domainFn: (datum, _) => datum.domain,
measureFn: (datum, _) => datum.measure,
data: variable.values,
),
],
animate: true,
dateTimeFactory: const charts.LocalDateTimeFactory(),
behaviors: [charts.SeriesLegend()],
),
),
),
],
);
},
),
),
),
);
}
}


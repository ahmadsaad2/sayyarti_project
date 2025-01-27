import 'package:flutter/material.dart';
import 'package:sayyarti/Screens/admin/widgets/admin_drawer.dart';
import 'package:sayyarti/Screens/admin/widgets/stat.dart';
import 'package:sayyarti/Screens/admin/widgets/table.dart';
import 'package:sayyarti/model/statistics.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  late Future<Statistics> futureStatistics;
  var _isCharts = true;

  @override
  void initState() {
    super.initState();
    futureStatistics =
        fetchStatistics().then((data) => Statistics.fromJson(data));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 49, 87, 194),
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminHome(),
                    ),
                  );
                },
                icon: Icon(Icons.refresh))
          ],
          centerTitle: true,
        ),
        drawer: const AdminDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isCharts = false;
                      });
                    },
                    icon: Icon(Icons.table_chart_outlined),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isCharts = true;
                      });
                    },
                    icon: Icon(Icons.pie_chart_outline),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FutureBuilder<Statistics>(
                future: futureStatistics,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No data found'));
                  } else {
                    return _isCharts
                        ? Statistic(stats: snapshot.data!)
                        : AllDataTable(stats: snapshot.data!);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

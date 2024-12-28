import 'package:flutter/material.dart';
import 'service_details_page.dart';
import 'spare_part_details_page.dart';

class TrackingStep {
  final String step;
  final String description;
  final bool isCompleted;

  TrackingStep({
    required this.step,
    required this.description,
    required this.isCompleted,
  });
}

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Default tracking steps
  final List<TrackingStep> defaultTrackingSteps = [
    TrackingStep(
      step: 'Waiting for approval of the request',
      description: 'Your request is waiting for approval.',
      isCompleted: false,
    ),
    TrackingStep(
      step: 'Waiting for receipt',
      description: 'We are waiting to receive your car.',
      isCompleted: false,
    ),
    TrackingStep(
      step: 'The car has been delivered',
      description: 'Your car has been delivered to the garage.',
      isCompleted: false,
    ),
    TrackingStep(
      step: 'Try the inspection and diagnosis',
      description: 'Inspection and diagnosis are in progress.',
      isCompleted: false,
    ),
    TrackingStep(
      step: 'Work in progress',
      description: 'Repair work is currently in progress.',
      isCompleted: false,
    ),
    TrackingStep(
      step: 'Testing the quality of the repair',
      description: 'We are testing the quality of the repair.',
      isCompleted: false,
    ),
    TrackingStep(
      step: 'Your car is ready for receipt',
      description: 'Your car is ready for you to pick up.',
      isCompleted: false,
    ),
    TrackingStep(
      step: 'The task is complete',
      description: 'The repair task is complete.',
      isCompleted: false,
    ),
  ];

  final List<Map<String, dynamic>> allOrders = [
    {
      'title': 'Order #1',
      'type': 'Service',
      'status': 'Pending',
      'date': '2024-12-28',
      'customerName': 'Ahmad',
      'phoneNumber': '2323',
      'problemDetails': 'Oil leakage detected.',
      'preferredTime': '9-10',
      'method': 'Pickup',
      'problemImageOrVideo': 'Not attached',
      'carLicense': '123-XYZ',
      'garageName': 'ABC Garage',
      'trackingSteps': [
        {
          'step': 'Waiting for approval of the request',
          'isCompleted': true,
        },
        {
          'step': 'Waiting for receipt',
          'isCompleted': true,
        },
        {
          'step': 'The car has been delivered',
          'isCompleted': true,
        },
      ],
    },
    {
      'title': 'Order #2',
      'type': 'Order',
      'status': 'Completed',
      'date': '2024-12-29',
      'customerName': 'Sara',
      'phoneNumber': '3456',
      'problemDetails': 'Tire replacement.',
      'preferredTime': '10-11',
      'method': 'Drop-off',
      'problemImageOrVideo': 'Not attached',
      'carLicense': '456-ABC',
      'garageName': 'XYZ Garage',
      'trackingSteps': [
        {
          'step': 'Order received',
          'isCompleted': true,
        },
        {
          'step': 'Processing the order',
          'isCompleted': true,
        },
        {
          'step': 'Order completed',
          'isCompleted': true,
        },
      ],
    },
  ];

  String selectedTab = "All";
  List<Map<String, dynamic>> filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedTab = _getTabLabel(_tabController.index);
        _filterOrders();
      });
    });
    _filterOrders();
  }

  String _getTabLabel(int index) {
    switch (index) {
      case 0:
        return "All";
      case 1:
        return "Service";
      case 2:
        return "Order";
      default:
        return "All";
    }
  }

  void _filterOrders() {
    setState(() {
      filteredOrders = selectedTab == "All"
          ? allOrders
          : allOrders.where((order) => order['type'] == selectedTab).toList();
    });
  }

  List<TrackingStep> _mergeTrackingSteps(List<dynamic> orderSteps) {
    final Map<String, bool> stepsMap = {
      for (var step in orderSteps) step['step']: step['isCompleted'] as bool,
    };

    return defaultTrackingSteps.map((defaultStep) {
      final isCompleted = stepsMap[defaultStep.step] ?? false;
      return TrackingStep(
        step: defaultStep.step,
        description: defaultStep.description,
        isCompleted: isCompleted,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color.fromARGB(255, 2, 4, 104),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Service'),
            Tab(text: 'Order'),
          ],
        ),
      ),
      body: filteredOrders.isEmpty
          ? _buildEmptyState()
          : _buildOrdersList(filteredOrders),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            child: Image.asset(
              'assets/images/no_orders.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No orders yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<Map<String, dynamic>> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return GestureDetector(
          onTap: () => _navigateToOrderDetails(context, order),
          child: Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order['title'] ?? 'Unknown Order',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Garage: ${order['garageName']}'),
                  Text('Type: ${order['type']}'),
                  Text('Status: ${order['status']}'),
                  Text('Date: ${order['date']}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToOrderDetails(
      BuildContext context, Map<String, dynamic> order) {
    if (order['type'] == 'Service') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceDetailsPage(
            orderDetails: order.map((key, value) =>
                MapEntry(key, value.toString())), // Convert all to strings
            trackingSteps: _mergeTrackingSteps(order['trackingSteps'] as List),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SparePartDetailsPage(
            orderDetails: order.map((key, value) =>
                MapEntry(key, value.toString())), // Convert all to strings
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

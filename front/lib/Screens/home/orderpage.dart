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
          'description': 'Your request is waiting for approval.',
          'isCompleted': true,
        },
        {
          'step': 'Waiting for receipt',
          'description': 'We are waiting to receive your car.',
          'isCompleted': false,
        },
        {
          'step': 'Waiting for receipt',
          'description': 'We are waiting to receive your car.',
          'isCompleted': false,
        },
      ]
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
          'description': 'Your order has been received.',
          'isCompleted': true,
        },
        {
          'step': 'Processing the order',
          'description': 'Your order is being processed.',
          'isCompleted': true,
        },
        {
          'step': 'Order completed',
          'description': 'The task is complete.',
          'isCompleted': true,
        },
      ]
    },
  ];

  String selectedTab = "All";
  String selectedType = "All";
  String selectedStatus = "All";
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

      if (selectedType != "All") {
        filteredOrders = filteredOrders
            .where((order) => order['type'] == selectedType)
            .toList();
      }

      if (selectedStatus != "All") {
        filteredOrders = filteredOrders
            .where((order) => order['status'] == selectedStatus)
            .toList();
      }
    });
  }

  void _applyOrderFilters() async {
    final filters = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        String tempType = selectedType;
        String tempStatus = selectedStatus;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filter Orders'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: tempType,
                    onChanged: (value) {
                      setState(() {
                        tempType = value!;
                      });
                    },
                    items: ['All', 'Service', 'Order']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                  ),
                  DropdownButton<String>(
                    value: tempStatus,
                    onChanged: (value) {
                      setState(() {
                        tempStatus = value!;
                      });
                    },
                    items: ['All', 'Pending', 'Completed']
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                        context, {'type': tempType, 'status': tempStatus});
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );

    if (filters != null) {
      setState(() {
        selectedType = filters['type']!;
        selectedStatus = filters['status']!;
        _filterOrders();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: _applyOrderFilters,
          ),
        ],
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
            orderDetails:
                order.map((key, value) => MapEntry(key, value.toString())),
            trackingSteps: (order['trackingSteps'] as List)
                .map((step) => TrackingStep(
                      step: step['step'] as String,
                      description: step['description'] as String,
                      isCompleted: step['isCompleted'] as bool,
                    ))
                .toList(),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SparePartDetailsPage(
            orderDetails:
                order.map((key, value) => MapEntry(key, value.toString())),
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

import 'package:flutter/material.dart';
import 'service_details_page.dart';
import 'spare_part_details_page.dart';
import 'emergency.dart';
import '../../../model/assistancerequest.dart';

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
  const OrdersPage({super.key});

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

  final List<Map<String, dynamic>> selectedOffers1 = [
    {
      "FLAT20": {
        "description": "FLAT20",
        "Type": "Flat",
        "Amount": "20",
        "Minimum": "100",
        "Start": "2023-11-15",
        "End": "2023-11-30",
      },
    },
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
      ],
    },
    {
      'title': 'Order #2',
      'type': 'Service',
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
    {
      'title': 'Order #3',
      'type': 'AssistanceRequest',
      'status': 'Pending',
      'userId': 1,
      'serviceType': 'Towing',
      'requestDate': '2024-12-28T10:00:00Z',
      'vehicleMakeModel': 'Toyota Camry',
      'vehicleType': 'Car',
      'licensePlate': '123-XYZ',
      'vehicleCondition': 'Non-drivable',
      'currentLocationAddress': '123 Main St, Nablus',
      'nearestLandmark': 'Near City Center',
      'latitude': 32.2211,
      'longitude': 35.2544,
      'customerName': 'Ahmad',
      'phoneNumber': '0591234567',
      'alternativeContact': '0597654321',
      'towingType': 'Flatbed Tow',
      'preferredDropOffPoint': 'Repair Shop',
    },
    {
      'title': 'Order #4',
      'type': 'Order',
      'status': 'Completed',
      'offers': [
        {
          "FLAT20": {
            "description": "FLAT20",
            "Type": "Flat",
            "Amount": "20",
            "Minimum": "100",
            "Start": "2023-11-15",
            "End": "2023-11-30",
          },
        },
      ],
    },
  ];

  String selectedTab = "All";
  String selectedType = "All";
  String selectedStatus = "All";
  int selectedOrderCount = 0;
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
      // Start with type filter from the tab
      List<Map<String, dynamic>> filtered = selectedTab == "All"
          ? allOrders
          : allOrders.where((order) => order['type'] == selectedTab).toList();

      // Apply type filter from filter dialog
      if (selectedType != "All") {
        filtered =
            filtered.where((order) => order['type'] == selectedType).toList();
      }

      // Apply status filter
      if (selectedStatus != "All") {
        filtered = filtered
            .where((order) => order['status'] == selectedStatus)
            .toList();
      }

      // Apply order count filter (limit number of results)
      if (selectedOrderCount > 0) {
        filtered = filtered.take(selectedOrderCount).toList();
      }

      filteredOrders = filtered;
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
    // Check if there are any orders of type 'Order'
    final hasOrderType = orders.any((order) => order['type'] == 'Order');

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Orders Section
        if (orders.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Orders',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...orders.map((order) {
            final isOfferOrder = order['type'] == 'Order';

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
                      Text('Type: ${order['type']}'),
                      Text('Status: ${order['status']}'),
                      Text('Date: ${order['date']}'),
                      if (isOfferOrder) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Offers:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...(order['offers'] as List<Map<String, dynamic>>?)
                                ?.map((offerMap) {
                              final offerKey = offerMap.keys.first;
                              final offerDetails = offerMap[offerKey];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.local_offer,
                                        color: Colors.green, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${offerDetails['description']} - ${offerDetails['Type']} ${offerDetails['Amount']}%',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }) ??
                            [],
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  void _navigateToOrderDetails(
      BuildContext context, Map<String, dynamic> order) {
    if (order['type'] == 'Service') {
      // Navigate to ServiceDetailsPage for Service type
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
    } else if (order['type'] == 'AssistanceRequest') {
      // Convert the order map to an AssistanceRequest object
      AssistanceRequest request = AssistanceRequest(
        userId: order['userId'],
        serviceType: order['serviceType'],
        requestDate: order['requestDate'] != null
            ? DateTime.parse(order['requestDate'])
            : null,
        vehicleMakeModel: order['vehicleMakeModel'],
        vehicleType: order['vehicleType'],
        licensePlate: order['licensePlate'],
        vehicleCondition: order['vehicleCondition'],
        currentLocationAddress: order['currentLocationAddress'],
        nearestLandmark: order['nearestLandmark'],
        latitude: order['latitude'],
        longitude: order['longitude'],
        customerName: order['customerName'],
        phoneNumber: order['phoneNumber'],
        alternativeContact: order['alternativeContact'],
        towingType: order['towingType'],
        preferredDropOffPoint: order['preferredDropOffPoint'],
      );

      // Navigate to AssistanceRequestDetailsPage for AssistanceRequest type
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AssistanceRequestDetailsPage(
            request: request,
          ),
        ),
      );
    } else if (order['type'] == 'Order') {
      // Navigate to OfferDetailsPage for Order type
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OfferDetailsPage(
            selectedOffers: order['offers'] ?? [],
          ),
        ),
      );
    }
  }

  void _applyOrderFilters() async {
    final Map<String, dynamic>? filters =
        await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        String tempSelectedType = selectedType;
        String tempSelectedStatus = selectedStatus;
        int tempSelectedOrderCount = selectedOrderCount;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Filter Content'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filter by Type:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: tempSelectedType,
                    onChanged: (String? newValue) {
                      setState(() {
                        tempSelectedType = newValue!;
                      });
                    },
                    items: ['All', 'Service', 'AssistanceRequest', 'Order']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Filter by Status:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: tempSelectedStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        tempSelectedStatus = newValue!;
                      });
                    },
                    items: ['All', 'Pending', 'Completed', 'In Progress']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Limit Results:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: tempSelectedOrderCount.toDouble(),
                    min: 0,
                    max: 20,
                    divisions: 20,
                    label: tempSelectedOrderCount.toString(),
                    onChanged: (double value) {
                      setState(() {
                        tempSelectedOrderCount = value.toInt();
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Apply'),
                  onPressed: () {
                    Navigator.pop(context, {
                      'type': tempSelectedType,
                      'status': tempSelectedStatus,
                      'orderCount': tempSelectedOrderCount,
                    });
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (filters != null) {
      setState(() {
        selectedType = filters['type'];
        selectedStatus = filters['status'];
        selectedOrderCount = filters['orderCount'];
        _filterOrders(); // Call filter logic
      });
    }
  }
}

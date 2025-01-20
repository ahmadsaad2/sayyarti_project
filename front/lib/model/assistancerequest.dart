class AssistanceRequest {
  List<AssistanceRequest> dummyAssistanceRequests = [];

  void addRequest(AssistanceRequest request) {
    dummyAssistanceRequests.add(request);
    print('Request added to dummy list:');
    print(request);
  }

  // Get all requests from the list
  List<AssistanceRequest> getAllRequests() {
    return dummyAssistanceRequests;
  }

  // Print all requests in the list
  void printAllRequests() {
    print('All Assistance Requests:');
    for (var request in dummyAssistanceRequests) {
      print(request);
    }
  }

  final int? id; // Unique ID for the request (auto-incremented in the database)
  final int? userId; // ID of the user making the request
  final String?
      serviceType; // Type of service (e.g., Jump Start, Tire Problem, Towing, Fuel Delivery)
  final DateTime? requestDate; // Date and time when the request was made

  // Vehicle Details (Common for all services)
  final String? vehicleMakeModel;
  final String? vehicleType;
  final String? batteryType; // Optional for Jump Start and Fuel Delivery
  final String? licensePlate; // For Towing Services
  final String? vehicleCondition; // For Towing Services

  // Problem Description (Common for Jump Start and Tire Problem)
  final String? issueDescription;
  final String? additionalNotes;

  // Location Details (Common for all services)
  final String? currentLocationAddress;
  final String? nearestLandmark;
  final double? latitude; // Latitude of the selected location
  final double? longitude; // Longitude of the selected location

  // Assistance Options (Common for all services)
  final bool? immediateAssistance;
  final DateTime? scheduledTime; // For scheduled assistance
  final String? requestedService; // For Tire Problem and Towing Services
  final String? towingType; // For Towing Services
  final String? preferredDropOffPoint; // For Towing Services

  // Fuel Delivery Specific Fields
  final String? fuelType; // For Fuel Delivery
  final double? fuelQuantity; // For Fuel Delivery
  final double? totalPrice; // For Fuel Delivery

  // Contact Information (Common for all services)
  final String? customerName;
  final String? phoneNumber;
  final String? alternativeContact; // Optional

  // Constructor with all parameters optional
  AssistanceRequest({
    this.id,
    this.userId,
    this.serviceType,
    this.requestDate,
    this.vehicleMakeModel,
    this.vehicleType,
    this.batteryType,
    this.licensePlate,
    this.vehicleCondition,
    this.issueDescription,
    this.additionalNotes,
    this.currentLocationAddress,
    this.nearestLandmark,
    this.latitude,
    this.longitude,
    this.immediateAssistance,
    this.scheduledTime,
    this.requestedService,
    this.towingType,
    this.preferredDropOffPoint,
    this.fuelType,
    this.fuelQuantity,
    this.totalPrice,
    this.customerName,
    this.phoneNumber,
    this.alternativeContact,
  });

  // Convert the model to a JSON map for sending to the backend
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'serviceType': serviceType,
      'requestDate': requestDate?.toIso8601String(),
      'vehicleMakeModel': vehicleMakeModel,
      'vehicleType': vehicleType,
      'batteryType': batteryType,
      'licensePlate': licensePlate,
      'vehicleCondition': vehicleCondition,
      'issueDescription': issueDescription,
      'additionalNotes': additionalNotes,
      'currentLocationAddress': currentLocationAddress,
      'nearestLandmark': nearestLandmark,
      'latitude': latitude,
      'longitude': longitude,
      'immediateAssistance': immediateAssistance,
      'scheduledTime': scheduledTime?.toIso8601String(),
      'requestedService': requestedService,
      'towingType': towingType,
      'preferredDropOffPoint': preferredDropOffPoint,
      'fuelType': fuelType,
      'fuelQuantity': fuelQuantity,
      'totalPrice': totalPrice,
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'alternativeContact': alternativeContact,
    };
  }

  // Create a model from a JSON map (for receiving data from the backend)
  factory AssistanceRequest.fromJson(Map<String, dynamic> json) {
    return AssistanceRequest(
      id: json['id'],
      userId: json['userId'],
      serviceType: json['serviceType'],
      requestDate: json['requestDate'] != null
          ? DateTime.parse(json['requestDate'])
          : null,
      vehicleMakeModel: json['vehicleMakeModel'],
      vehicleType: json['vehicleType'],
      batteryType: json['batteryType'],
      licensePlate: json['licensePlate'],
      vehicleCondition: json['vehicleCondition'],
      issueDescription: json['issueDescription'],
      additionalNotes: json['additionalNotes'],
      currentLocationAddress: json['currentLocationAddress'],
      nearestLandmark: json['nearestLandmark'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      immediateAssistance: json['immediateAssistance'],
      scheduledTime: json['scheduledTime'] != null
          ? DateTime.parse(json['scheduledTime'])
          : null,
      requestedService: json['requestedService'],
      towingType: json['towingType'],
      preferredDropOffPoint: json['preferredDropOffPoint'],
      fuelType: json['fuelType'],
      fuelQuantity: json['fuelQuantity'],
      totalPrice: json['totalPrice'],
      customerName: json['customerName'],
      phoneNumber: json['phoneNumber'],
      alternativeContact: json['alternativeContact'],
    );
  }
}

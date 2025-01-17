class OffersManager {
  // Singleton instance
  static final OffersManager _instance = OffersManager._internal();

  // Private constructor
  OffersManager._internal();

  // Access point for the singleton
  static OffersManager get instance => _instance;

  // Offers list
  final List<Map<String, String>> _offers = [
    {
      "description": "OFF10",
      "Type": "Percentage",
      "Amount": "10",
      "Minimum": "50",
      "Start": "2023-12-01",
      "End": "2023-12-31",
    },
    {
      "description": "FLAT20",
      "Type": "Flat",
      "Amount": "20",
      "Minimum": "100",
      "Start": "2023-11-15",
      "End": "2023-11-30",
    },
  ];

  // Getter for offers
  List<Map<String, String>> get offers => _offers;

  // Method to add an offer
  void addOffer(Map<String, String> offer) {
    _offers.add(offer);
  }

  // Method to update an offer
  void updateOffer(int index, Map<String, String> updatedOffer) {
    if (index >= 0 && index < _offers.length) {
      _offers[index] = updatedOffer;
    }
  }

  // Method to delete an offer
  void deleteOffer(int index) {
    if (index >= 0 && index < _offers.length) {
      _offers.removeAt(index);
    }
  }
}

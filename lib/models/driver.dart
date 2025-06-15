class Driver {
  final String id;
  final String userId;
  final String licenseNumber;
  final String vehicleModel;
  final String vehiclePlate;
  final String vehicleColor;
  final DriverStatus status;
  final double rating;
  final int totalRides;
  final double? currentLatitude;
  final double? currentLongitude;
  final DateTime? lastLocationUpdate;

  Driver({
    required this.id,
    required this.userId,
    required this.licenseNumber,
    required this.vehicleModel,
    required this.vehiclePlate,
    required this.vehicleColor,
    required this.status,
    required this.rating,
    required this.totalRides,
    this.currentLatitude,
    this.currentLongitude,
    this.lastLocationUpdate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'licenseNumber': licenseNumber,
      'vehicleModel': vehicleModel,
      'vehiclePlate': vehiclePlate,
      'vehicleColor': vehicleColor,
      'status': status.toString(),
      'rating': rating,
      'totalRides': totalRides,
      'currentLatitude': currentLatitude,
      'currentLongitude': currentLongitude,
      'lastLocationUpdate': lastLocationUpdate?.toIso8601String(),
    };
  }

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      userId: json['userId'],
      licenseNumber: json['licenseNumber'],
      vehicleModel: json['vehicleModel'],
      vehiclePlate: json['vehiclePlate'],
      vehicleColor: json['vehicleColor'],
      status: DriverStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      rating: json['rating']?.toDouble() ?? 0.0,
      totalRides: json['totalRides'] ?? 0,
      currentLatitude: json['currentLatitude']?.toDouble(),
      currentLongitude: json['currentLongitude']?.toDouble(),
      lastLocationUpdate: json['lastLocationUpdate'] != null
          ? DateTime.parse(json['lastLocationUpdate'])
          : null,
    );
  }
}

enum DriverStatus { offline, online, busy }

class Ride {
  final String id;
  final String riderId;
  final String? driverId;
  final String pickupAddress;
  final String destinationAddress;
  final LatLng pickupLocation;
  final LatLng destinationLocation;
  final RideStatus status;
  final RideType rideType;
  final double estimatedFare;
  final double? actualFare;
  final DateTime requestTime;
  final DateTime? acceptTime;
  final DateTime? startTime;
  final DateTime? endTime;
  final double? rating;
  final String? feedback;

  Ride({
    required this.id,
    required this.riderId,
    this.driverId,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.status,
    required this.rideType,
    required this.estimatedFare,
    this.actualFare,
    required this.requestTime,
    this.acceptTime,
    this.startTime,
    this.endTime,
    this.rating,
    this.feedback,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'riderId': riderId,
      'driverId': driverId,
      'pickupAddress': pickupAddress,
      'destinationAddress': destinationAddress,
      'pickupLocation': {
        'latitude': pickupLocation.latitude,
        'longitude': pickupLocation.longitude,
      },
      'destinationLocation': {
        'latitude': destinationLocation.latitude,
        'longitude': destinationLocation.longitude,
      },
      'status': status.toString(),
      'rideType': rideType.toString(),
      'estimatedFare': estimatedFare,
      'actualFare': actualFare,
      'requestTime': requestTime.toIso8601String(),
      'acceptTime': acceptTime?.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'rating': rating,
      'feedback': feedback,
    };
  }

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      riderId: json['riderId'],
      driverId: json['driverId'],
      pickupAddress: json['pickupAddress'],
      destinationAddress: json['destinationAddress'],
      pickupLocation: LatLng(
        json['pickupLocation']['latitude'],
        json['pickupLocation']['longitude'],
      ),
      destinationLocation: LatLng(
        json['destinationLocation']['latitude'],
        json['destinationLocation']['longitude'],
      ),
      status: RideStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      rideType: RideType.values.firstWhere(
        (e) => e.toString() == json['rideType'],
      ),
      estimatedFare: json['estimatedFare']?.toDouble() ?? 0.0,
      actualFare: json['actualFare']?.toDouble(),
      requestTime: DateTime.parse(json['requestTime']),
      acceptTime: json['acceptTime'] != null
          ? DateTime.parse(json['acceptTime'])
          : null,
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'])
          : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      rating: json['rating']?.toDouble(),
      feedback: json['feedback'],
    );
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}

enum RideStatus {
  requested,
  accepted,
  driverArriving,
  inProgress,
  completed,
  cancelled,
}

enum RideType { economy, premium, xl }

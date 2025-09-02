class VisitActivity {
  final String appointmentID;
  final String userID;
  final String clientID;
  final String? outcomeID;
  final String? checkInTime;
  final String? checkOutTime;
  final double? checkInLatitude;
  final double? checkInLongitude;
  final double? checkOutLatitude;
  final double? checkOutLongitude;
  final String? notes;

  VisitActivity({
    required this.appointmentID,
    required this.userID,
    required this.clientID,
    this.outcomeID,
    this.checkInTime,
    this.checkOutTime,
    this.checkInLatitude,
    this.checkInLongitude,
    this.checkOutLatitude,
    this.checkOutLongitude,
    this.notes,
  });

  factory VisitActivity.fromJson(Map<String, dynamic> json) {
    return VisitActivity(
      appointmentID: json['AppointmentID'],
      userID: json['UserID'],
      clientID: json['ClientID'],
      outcomeID: json['OutcomeID'],
      checkInTime: json['CheckInTime'],
      checkOutTime: json['CheckOutTime'],
      checkInLatitude: json['CheckInLatitude'],
      checkInLongitude: json['CheckInLongitude'],
      checkOutLatitude: json['CheckOutLatitude'],
      checkOutLongitude: json['CheckOutLongitude'],
      notes: json['Notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AppointmentID': appointmentID,
      'UserID': userID,
      'ClientID': clientID,
      'OutcomeID': outcomeID,
      'CheckInTime': checkInTime,
      'CheckOutTime': checkOutTime,
      'CheckInLatitude': checkInLatitude,
      'CheckInLongitude': checkInLongitude,
      'CheckOutLatitude': checkOutLatitude,
      'CheckOutLongitude': checkOutLongitude,
      'Notes': notes,
    };
  }

  static List<VisitActivity> listFromJson(List<dynamic> jsonList) => jsonList.map((e) => VisitActivity.fromJson(e as Map<String, dynamic>)).toList();

  VisitActivity copyWith({
    String? appointmentID,
    String? userID,
    String? clientID,
    String? outcomeID,
    String? checkInTime,
    String? checkOutTime,
    double? checkInLatitude,
    double? checkInLongitude,
    double? checkOutLatitude,
    double? checkOutLongitude,
    String? notes,
  }) {
    return VisitActivity(
      appointmentID: appointmentID ?? this.appointmentID,
      userID: userID ?? this.userID,
      clientID: clientID ?? this.clientID,
      outcomeID: outcomeID ?? this.outcomeID,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      checkInLatitude: checkInLatitude ?? this.checkInLatitude,
      checkInLongitude: checkInLongitude ?? this.checkInLongitude,
      checkOutLatitude: checkOutLatitude ?? this.checkOutLatitude,
      checkOutLongitude: checkOutLongitude ?? this.checkOutLongitude,
      notes: notes ?? this.notes,
    );
  }
}

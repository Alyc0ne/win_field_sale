class VisitActivity {
  final String appointmentID;
  final String userID;
  final String clientID;
  final String outcomeID;
  final String checkInTime;
  final String checkOutTime;
  final double checkInLatitude;
  final double checkInLongitude;
  final double checkOutLatitude;
  final double checkOutLongitude;
  final String notes;

  VisitActivity({
    required this.appointmentID,
    required this.userID,
    required this.clientID,
    required this.outcomeID,
    required this.checkInTime,
    required this.checkOutTime,
    required this.checkInLatitude,
    required this.checkInLongitude,
    required this.checkOutLatitude,
    required this.checkOutLongitude,
    required this.notes,
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
}

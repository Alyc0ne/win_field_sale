import 'package:win_field_sale/features/appointment/models/appointment.dart';
import 'package:win_field_sale/features/appointment/services/appointment_service.dart';

class AppointmentViewModel {
  final AppointmentService _appointmentService = AppointmentService();

  Future<List<Appointment>> fetchAppointments() async => await _appointmentService.fetchAppointments();
}

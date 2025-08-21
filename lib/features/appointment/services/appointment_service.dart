import 'package:win_field_sale/core/http/api_client.dart';
import 'package:win_field_sale/features/appointment/models/appointment.dart';
import 'package:win_field_sale/features/appointment/models/appointment_detail.dart';
import 'package:win_field_sale/features/appointment/models/product.dart';

class AppointmentService {
  final apiClient = ApiClient('https://sfe-api.appnormalthink.com');
  final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJzeXN0ZW1hZG1pbkBtYWlsLmNvbSIsImV4cCI6MTc1NTgyMDEzOX0.kAVC1mpwwjj2bljLbDBKTUu2ZEZNf9adEVMWrIJN9t0";

  Future<List<Appointment>> fetchAppointments() async {
    final appointments = await apiClient.get(
      path: "/appointment/?IsActive=true", //&AppointmentDate=2025-08-04&UserID=9E0DC5F7-1FD6-41F3-9137-14711FC510F6
      decode: (json) {
        final map = json as Map<String, dynamic>;
        final list = map['appointments'] as List? ?? const [];
        return Appointment.listFromJson(list);
      },
      headers: {"Authorization": "Bearer $token"},
    );

    return appointments;
  }

  Future<AppointmentDetail> fetchAppointmentById(appointmentID) async {
    final appointment = await apiClient.get(
      path: "/appointment/id/$appointmentID",
      decode: (json) => AppointmentDetail.fromJson((json as Map<String, dynamic>)["appointment"]),
      headers: {"Authorization": "Bearer $token"},
    );

    return appointment;
  }

  Future<List<Product>> fetchProducts() async {
    final products = await apiClient.get(
      path: "/product/?SearchName=Test&IsActive=true",
      decode: (json) {
        final map = json as Map<String, dynamic>;
        final list = map['products'] as List? ?? const [];
        return Product.listFromJson(list);
      },
      headers: {"Authorization": "Bearer $token"},
    );

    return products;
  }
}

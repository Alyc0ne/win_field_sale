import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:win_field_sale/core/base_provider.dart';
import 'package:win_field_sale/features/appointment/models/appointment_detail.dart';
import 'package:win_field_sale/features/appointment/models/outcome.dart';
import 'package:win_field_sale/features/appointment/models/visit_activities.dart';
import 'package:win_field_sale/features/appointment/services/appointment_service.dart';
import 'package:win_field_sale/features/appointment/views/appointment_visit_page.dart';
import 'package:win_field_sale/services/location_service.dart';

@immutable
class AppointmentVisitState {
  final AsyncValue<AppointmentDetail> data;
  final AsyncValue<Location?> location;
  final VisitActivity? visitActivity;
  final bool isLoading;

  const AppointmentVisitState({required this.data, required this.location, this.visitActivity, this.isLoading = false});

  AppointmentVisitState copyWith({AsyncValue<AppointmentDetail>? data, AsyncValue<Location?>? location, VisitActivity? visitActivity, bool? isLoading}) {
    return AppointmentVisitState(data: data ?? this.data, location: location ?? this.location, visitActivity: visitActivity ?? this.visitActivity, isLoading: isLoading ?? this.isLoading);
  }
}

class AppointmentVisitViewModel extends StateNotifier<AppointmentVisitState> {
  AppointmentVisitViewModel(this.ref, this.id) : super(const AppointmentVisitState(data: AsyncValue.loading(), location: AsyncValue.loading())) {
    fetch();
  }

  final Ref ref;
  final String id;

  AppointmentService get _appointmentService => ref.read(appointmentServiceProvider);
  final _locationService = LocationService();

  Future<Location?> fetchLocation() async {
    final permission = await _locationService.requestPermission(requestIfDenied: false);
    if (permission != LocationPermissionStatus.granted) return null;

    final pos = await _locationService.getPosition();
    print('pos: $pos');
    final address = await _locationService.reverseGeocodeGoogle(pos.latitude, pos.longitude);
    return Location(lat: pos.latitude, lng: pos.longitude, address: address);
  }

  Future<void> fetch() async {
    final resAppointment = await AsyncValue.guard(() => _appointmentService.fetchAppointmentById(id));

    state = state.copyWith(data: resAppointment);

    resAppointment.whenData((appointmentDetail) {
      state = state.copyWith(
        visitActivity: VisitActivity(
          activityID: appointmentDetail.visitActivities.isNotEmpty ? appointmentDetail.visitActivities.first.activityID : null,
          appointmentID: appointmentDetail.appointmentId,
          userID: appointmentDetail.userId,
          clientID: appointmentDetail.clientId,
          outcomeID: appointmentDetail.visitActivities.isNotEmpty ? appointmentDetail.visitActivities.first.outcomeID : null,
          createdBy: appointmentDetail.createdBy,
          modifiedBy: appointmentDetail.modifiedBy,
          isActive: appointmentDetail.isActive,
        ),
      );
    });

    print('state.visitActivity?.outcomeID: ${state.visitActivity?.outcomeID}');

    if ((state.visitActivity?.outcomeID ?? '').isEmpty) {
      final resLocation = await AsyncValue.guard(fetchLocation);
      state = state.copyWith(location: resLocation);
    }
  }

  void setNotes(String notes) {
    state = state.copyWith(visitActivity: state.visitActivity?.copyWith(notes: notes));
  }

  void setOutcome(Outcome outcome) {
    state = state.copyWith(visitActivity: state.visitActivity?.copyWith(outcomeID: outcome.outcomeID, outcomeName: outcome.outcomeName));
  }

  bool validateOutcome() {
    return state.visitActivity?.outcomeID != null;
  }

  void loading(bool isLoading) => state = state.copyWith(isLoading: isLoading);

  Future<bool> checkIn({required double latitude, required double longitude, required String imgBase64}) async {
    if (state.visitActivity == null) return false;

    final now = DateTime.now();
    final checkInTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(now);

    state = state.copyWith(visitActivity: state.visitActivity!.copyWith(checkInTime: checkInTime, checkInLatitude: latitude, checkInLongitude: longitude));

    try {
      final result = await _appointmentService.checkIn(state.visitActivity!);
      if (result.ok) {
        return await _appointmentService.uploadImage(activityId: result.activityId, modifiedBy: result.modifiedBy, imgBase64: imgBase64);
      }
    } catch (e, st) {
      state = state.copyWith(data: AsyncError(e, st));
    } finally {
      loading(false);
    }

    return false;
  }

  Future<void> checkOut({required double latitude, required double longitude}) async {
    if (state.visitActivity == null) return;

    final now = DateTime.now();
    final checkOutTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(now);

    state = state.copyWith(isLoading: true);
    state = state.copyWith(visitActivity: state.visitActivity!.copyWith(checkOutTime: checkOutTime, checkOutLatitude: latitude, checkOutLongitude: longitude), isLoading: true);

    try {
      final result = await _appointmentService.checkOut(state.visitActivity!);
      print('result: $result');
    } catch (e, st) {
      state = state.copyWith(data: AsyncError(e, st));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

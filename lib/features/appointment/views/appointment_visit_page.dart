import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:win_field_sale/core/base_provider.dart';
import 'package:win_field_sale/features/appointment/models/appointment_detail.dart';
import 'package:win_field_sale/features/appointment/widgets/app_map.dart';
import 'package:win_field_sale/features/appointment/widgets/app_text.dart';
import 'package:win_field_sale/features/appointment/widgets/app_text_form_field.dart';
import 'package:win_field_sale/features/appointment/widgets/appointment_status.dart';
import 'package:win_field_sale/features/appointment/widgets/appointment_type.dart';
import 'package:win_field_sale/features/appointment/widgets/client_status.dart';
import 'package:win_field_sale/features/appointment/widgets/level_status.dart';
import 'package:win_field_sale/services/location_service.dart';

class AppointmentVisitPage extends ConsumerStatefulWidget {
  final String appointmentID;

  const AppointmentVisitPage({required this.appointmentID, super.key});

  @override
  ConsumerState<AppointmentVisitPage> createState() => _AppointmentVisitPageState();
}

class _AppointmentVisitPageState extends ConsumerState<AppointmentVisitPage> {
  static const colorPrimary = Color(0xFF007AFF);
  static const colorGray = Color.fromRGBO(60, 60, 67, 0.6);
  static const borderWidth = 0.33;
  static const borderSide = BorderSide(color: colorGray, width: borderWidth);

  final locationService = LocationService();
  late final Future<Position?> positionFuture;
  TextEditingController meetingNotedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    positionFuture = locationService.requestPermission(requestIfDenied: false).then((s) => s == LocationPermissionStatus.granted ? locationService.getPosition() : null);
  }

  Future<void> handleCheckIn() async {
    final status = await locationService.requestPermission();
    if (status != LocationPermissionStatus.granted) {
      if (!mounted) return;
      switch (status) {
        case LocationPermissionStatus.servicesOff:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please turn on Location Services.')));
          await Geolocator.openLocationSettings();
          return;
        case LocationPermissionStatus.denied:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission is required.')));
          return;
        case LocationPermissionStatus.deniedForever:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Permission permanently denied. Open settings.')));
          await Geolocator.openAppSettings();
          return;
        case LocationPermissionStatus.granted:
          break;
      }
    }

    final pos = await locationService.getPosition();
    print('pos: $pos');
    // TODO: recordAppointmentVisit(...) ด้วย pos และ now.toUtc()
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentEditProvider(widget.appointmentID));

    return state.data.when(
      loading: () => const Center(child: CircularProgressIndicator(color: colorPrimary)),
      error: (e, _) => Center(child: AppText(label: "Appointment Not Found", textColor: Colors.red)),
      data:
          (detail) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              backgroundColor: Color(0xFFEEEEEE),
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Color(0xFFEEEEEE),
                leadingWidth: 100,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      IconButton(icon: const Icon(Icons.chevron_left), onPressed: null, style: ButtonStyle(iconColor: WidgetStateProperty.all(colorPrimary))),
                      AppText(label: 'Back', textColor: colorPrimary),
                    ],
                  ),
                ),
                title: AppText(label: 'Edit Appointment', fontSize: 17, fontWeight: FontWeight.w600),
              ),
              body: buildContent(detail),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: SafeArea(
                minimum: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: 220,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => handleCheckIn(),
                    style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                    child: const AppText(label: 'Check In', fontSize: 17, textColor: Colors.white),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget buildContent(AppointmentDetail appointmentDetail) {
    final address = appointmentDetail.address;
    final client = appointmentDetail.client;

    final initialLat = address.latitude ?? 0;
    final initialLng = address.longitude ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        spacing: 16,
        children: [
          Column(
            spacing: 24,
            children: [
              Column(
                spacing: 6,
                children: [
                  AppText(label: '${client.firstName} ${client.lastName}', fontSize: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 6,
                    children: [
                      ClientStatus(clientStatusName: client.clientStatusName),
                      LevelStatus(levelStatusName: client.clientLevelName),
                      AppointmentType(appointmentTypeName: appointmentDetail.appointmentTypeName),
                      AppointmentStatus(appointmentStatusName: appointmentDetail.appointmentStatusName),
                    ],
                  ),
                ],
              ),
            ],
          ),

          FutureBuilder<Position?>(
            future: positionFuture,
            builder: (_, snap) {
              final pos = snap.data;
              return AppMap(lat: pos?.latitude ?? initialLat, lng: pos?.longitude ?? initialLng);
            },
          ),

          buildContentCard(title: 'current time', descWidget: AppText(label: 'DateFormat("hh:mm").format(now)', textColor: colorGray), fullWidth: true),
          buildContentCard(title: 'current location', descWidget: AppText(label: ' DateFormat("hh:mm").format(now)', textColor: colorGray), fullWidth: true),
          buildContentCard(
            title: 'meeting note',
            descWidget: AppTextFormField(controller: meetingNotedController, onChanged: (value) => ref.read(appointmentEditProvider(widget.appointmentID).notifier).setNoted(value), maxLines: 3),
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget buildContentCard({required String title, required Widget descWidget, bool fullWidth = false}) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(11)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [AppText(label: title, fontSize: 12), descWidget]),
    );
  }

  Widget infoTile({required String label, required Widget value, VoidCallback? onTap, double height = 44, bool isShowBorderMiddle = true, bool isShowBorderBottom = false, bool isHideIcon = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(top: borderSide, bottom: isShowBorderBottom ? borderSide : BorderSide.none)),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Container(
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(border: BorderDirectional(end: isShowBorderMiddle ? BorderSide(color: colorGray, width: borderWidth) : BorderSide.none)),
              child: AppText(label: label, textColor: const Color(0xFF007AFF)),
            ),
            const SizedBox(width: 16),
            Expanded(child: Align(alignment: Alignment.centerLeft, child: value)),
            if (!isHideIcon) ...[Icon(Icons.chevron_right, size: 24, color: colorGray), const SizedBox(width: 8)],
          ],
        ),
      ),
    );
  }
}

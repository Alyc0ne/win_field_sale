import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:win_field_sale/core/base_provider.dart';
import 'package:win_field_sale/features/appointment/models/appointment_detail.dart';
import 'package:win_field_sale/features/appointment/models/client.dart';
import 'package:win_field_sale/features/appointment/views/appointment_edit_page.dart';
import 'package:win_field_sale/features/appointment/widgets/app_map.dart';
import 'package:win_field_sale/features/appointment/widgets/app_text.dart';
import 'package:win_field_sale/features/appointment/widgets/appointment_status.dart';
import 'package:win_field_sale/features/appointment/widgets/client_status.dart';
import 'package:win_field_sale/features/appointment/widgets/level_status.dart';
import 'package:win_field_sale/features/appointment/widgets/meeting_status.dart';

class AppointmentDetailPage extends ConsumerStatefulWidget {
  final String appointmentID;
  const AppointmentDetailPage({required this.appointmentID, super.key});

  @override
  ConsumerState<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends ConsumerState<AppointmentDetailPage> {
  final baseLineHeight = 22;
  final colorPrimary = const Color(0xFF007AFF);
  final colorGray = const Color(0x993C3C43);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: Color(0xFFEEEEEE),
        leadingWidth: 80,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              IconButton(
                icon: Row(children: [const Icon(Icons.chevron_left), AppText(label: 'Back', textColor: colorPrimary)]),
                onPressed: null,
                style: ButtonStyle(iconColor: WidgetStateProperty.all(colorPrimary)),
              ),
            ],
          ),
        ),
        title: AppText(label: 'Appointment details', fontSize: 17, fontWeight: FontWeight.w600),
        actions: [
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => AppointmentEditPage(appointmentID: widget.appointmentID))),
            child: AppText(label: 'Edit', textColor: colorPrimary),
          ),
        ],
      ),
      body: Consumer(
        builder: (_, ref, _) {
          final state = ref.watch(appointmentDetailProvider(widget.appointmentID));

          return state.when(
            loading: () => Center(child: CircularProgressIndicator(color: colorPrimary)),
            error: (e, _) => Center(child: AppText(label: "Appointment Not Found: $e", textColor: Colors.red)),
            data: (detail) => buildContent(detail),
          );
        },
      ),
    );
  }

  Widget buildContent(AppointmentDetail appointmentDetail) {
    final addresses = appointmentDetail.addresses;
    final client = appointmentDetail.client;
    final salesTerritory = client.salesTerritory;
    final products = appointmentDetail.products;

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
                      MeetingStatus(meetingStatusName: ''),
                      AppointmentStatus(appointmentStatusName: appointmentDetail.appointmentStatusName),
                      ClientStatus(clientStatusName: client.clientStatusName),
                      LevelStatus(levelStatusName: client.clientLevelName),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  buildActionCard(icon: Icons.person, title: 'clients', onTap: () => print('client page')),
                  buildActionCard(icon: Icons.location_pin, title: 'map', onTap: () => print('map page')),
                  buildActionCard(icon: Icons.menu_book, title: 'check in', onTap: () => print('check in page')),
                  buildActionCard(icon: Icons.history, title: 'history', onTap: () => print('history page')),
                ],
              ),
            ],
          ),
          AppMap(lat: addresses.isNotEmpty ? addresses.first.latitude : null, lng: addresses.isNotEmpty ? addresses.first.longitude : null),
          buildContentCard(title: 'purpose', descWidget: AppText(label: appointmentDetail.purposeTypeName, textColor: colorPrimary), fullWidth: true),
          Row(
            spacing: 16,
            children: [
              Expanded(child: buildContentCard(title: 'time', descWidget: AppText(label: '${client.availableTimeStart} - ${client.availableTimeEnd}'))),
              Expanded(child: buildContentCard(title: 'territory', descWidget: AppText(label: salesTerritory?.salesTerritoryName ?? ''))),
            ],
          ),
          buildContentCard(title: 'address', descWidget: AppText(label: addresses.isNotEmpty ? addresses.first.address : ""), fullWidth: true),
          buildContentCard(title: 'mobile', descWidget: AppText(label: client.phone), fullWidth: true),
          buildContentCard(title: 'email', descWidget: AppText(label: client.email), fullWidth: true),
          buildContentCard(title: 'company', descWidget: AppText(label: appointmentDetail.companyName), fullWidth: true),
          buildContentCard(
            title: 'products',
            descWidget: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (_, index) {
                return Container(alignment: Alignment.centerLeft, height: 38, child: AppText(label: products[index].productName, textColor: colorPrimary));
              },
              separatorBuilder: (_, __) => const Divider(height: 0, thickness: 0.33, color: Color(0xFFC7C7CC)),
            ),
            fullWidth: true,
          ),
          buildContentCard(title: 'note', descWidget: AppText(label: client.noted, maxLines: null), fullWidth: true),
        ],
      ),
    );
  }

  Widget buildActionCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return Material(
      color: const Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: onTap,
        splashColor: const Color(0x33007AFF),
        highlightColor: Colors.transparent,
        child: Container(
          width: 66,
          height: 58,
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(icon, color: colorPrimary, size: 24), AppText(label: title, textColor: colorPrimary, fontSize: 12, lineHeight: 16)],
          ),
        ),
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
}

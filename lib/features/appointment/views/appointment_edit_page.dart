import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:win_field_sale/core/base_provider.dart';
import 'package:win_field_sale/features/appointment/models/appointment_detail.dart';
import 'package:win_field_sale/features/appointment/models/product.dart';
import 'package:win_field_sale/features/appointment/widgets/app_text.dart';
import 'package:win_field_sale/features/appointment/widgets/app_text_form_field.dart';
import 'package:win_field_sale/features/appointment/widgets/appointment_status.dart';
import 'package:win_field_sale/features/appointment/widgets/check_list_page.dart';
import 'package:win_field_sale/features/appointment/widgets/client_status.dart';
import 'package:win_field_sale/features/appointment/widgets/level_status.dart';

class AppointmentEditPage extends ConsumerStatefulWidget {
  final String appointmentID;
  const AppointmentEditPage({required this.appointmentID, super.key});

  @override
  ConsumerState<AppointmentEditPage> createState() => _AppointmentEditPageState();
}

class _AppointmentEditPageState extends ConsumerState<AppointmentEditPage> {
  static const colorPrimary = Color(0xFF007AFF);
  static const colorGrey = Color(0xFFC7C7CC);
  static const borderWidth = 0.33;
  static const borderSide = BorderSide(color: colorGrey, width: borderWidth);

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
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
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Done', style: TextStyle(color: colorPrimary)))],
        ),
        body: Consumer(
          builder: (_, ref, _) {
            final state = ref.watch(appointmentEditProvider(widget.appointmentID));

            return state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text('Error: $e'), const SizedBox(height: 8), TextButton(onPressed: null, child: const Text('Retry'))])),
              data: (detail) => buildContent(detail),
            );
          },
        ),
      ),
    );
  }

  Widget buildContent(AppointmentDetail appointmentDetail) {
    final addresses = appointmentDetail.addresses;
    final client = appointmentDetail.client;
    final salesTerritory = client.salesTerritory;
    final products = appointmentDetail.products;

    phoneController.text = client.phone;
    emailController.text = client.email;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 24,
        children: [
          AppText(label: '${client.firstName} ${client.lastName}', fontSize: 26),
          Column(
            spacing: 16,
            children: [
              Column(
                children: [
                  infoTile(label: 'status', value: ClientStatus(clientStatusName: 'Active'), onTap: () => print('tap')),
                  infoTile(label: 'level', value: LevelStatus(levelStatusName: 'A'), onTap: () => print('tap'), isShowBorderBottom: true),
                ],
              ),
              Column(
                children: [
                  infoTile(label: 'purpose', value: AppText(label: 'Initial Visit'), onTap: () => print('tap')),
                  infoTile(label: 'status', value: AppointmentStatus(appointmentStatusName: 'Scheduled'), onTap: () => print('tap')),
                  infoTile(label: 'territory', value: AppText(label: salesTerritory?.salesTerritoryName ?? ''), onTap: () => print('tap'), isShowBorderBottom: true),
                ],
              ),
              Column(
                children: [
                  infoTile(label: 'mobile', value: AppTextFormField(controller: phoneController), isHideIcon: true),
                  infoTile(label: 'email', value: AppTextFormField(controller: emailController), isHideIcon: true),
                  infoTile(label: 'company', value: AppText(label: salesTerritory?.salesTerritoryName ?? ''), onTap: () => print('tap'), isShowBorderBottom: true),
                ],
              ),
              productTile(),
              // Container(
              //   decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(top: borderSide, bottom: borderSide)),
              //   child: IntrinsicHeight(
              //     child: Row(
              //       children: [
              //         const SizedBox(width: 16),
              //         Container(
              //           width: 100,
              //           alignment: Alignment.center,
              //           decoration: const BoxDecoration(border: BorderDirectional(end: BorderSide(color: colorGrey, width: borderWidth))),
              //           child: AppText(label: 'products', textColor: const Color(0xFF007AFF)),
              //         ),
              //         const SizedBox(width: 16),
              //         Column(children: [AppText(label: 'label'), AppText(label: 'label'), AppText(label: 'label'), AppText(label: 'label')]),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget infoTile({required String label, required Widget value, VoidCallback? onTap, bool isShowBorderBottom = false, bool isHideIcon = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(top: borderSide, bottom: isShowBorderBottom ? borderSide : BorderSide.none)),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Container(
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(border: BorderDirectional(end: BorderSide(color: colorGrey, width: borderWidth))),
              child: AppText(label: label, textColor: const Color(0xFF007AFF)),
            ),
            const SizedBox(width: 16),
            Expanded(child: Align(alignment: Alignment.centerLeft, child: value)),
            if (!isHideIcon) ...[Icon(Icons.chevron_right, size: 24, color: colorGrey), const SizedBox(width: 8)],
          ],
        ),
      ),
    );
  }

  Widget productTile({bool isShowBorderBottom = false}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, border: const Border(top: borderSide, bottom: borderSide)),
      child: Stack(
        children: [
          const Positioned(left: 16 + 100, top: 0, bottom: 0, child: SizedBox(width: borderWidth, child: ColoredBox(color: colorGrey))),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 16),
              SizedBox(width: 100, child: Center(child: AppText(label: 'products', textColor: Color(0xFF007AFF)))),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (_, index) {
                        return Container(
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: colorGrey, width: borderWidth))),
                          height: 44,
                          child: Row(
                            children: const [SizedBox(width: 16), Icon(Icons.remove_circle, color: Color(0xFFFF382B), size: 24), SizedBox(width: 16), Expanded(child: AppText(label: 'label'))],
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return CheckListPage<Product, String>(
                                  title: 'เสียงเรียกเข้า',
                                  items: productsProvider,
                                  label: (item) => item.productName,
                                  keyOf: (item) => item.productId,
                                  initial: const ['C948FD64-E522-43FD-907E-0EDB3D5C0893', 'p_003'], // ให้ติ๊กไว้ล่วงหน้า
                                  // initial: const ['ค่าเริ่มต้น', 'เดินทาง'],
                                  // onChanged: (set) => debugPrint('current: $set'),
                                );
                              },
                            ),
                          ),
                      child: SizedBox(
                        height: 44,
                        child: Row(children: const [SizedBox(width: 16), Icon(Icons.add_circle, color: Color(0xFF31C859), size: 24), SizedBox(width: 16), AppText(label: 'add product')]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

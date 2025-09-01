import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:win_field_sale/features/appointment/views/appointment_detail_page.dart';
import 'package:win_field_sale/features/appointment/views/appointment_edit_page.dart';
import 'features/appointment/views/appointment_list_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // initialRoute: '/home',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomePage());

          case '/appointmentList':
            return MaterialPageRoute(settings: settings, builder: (_) => const AppointmentListPage());

          case '/appointmentDetail':
            final id = settings.arguments as String;
            return MaterialPageRoute(settings: settings, builder: (_) => AppointmentDetailPage(appointmentID: id));

          case '/appointmentEdit':
            final id = settings.arguments as String;
            return MaterialPageRoute<bool>(settings: settings, builder: (_) => AppointmentEditPage(appointmentID: id));
        }
        return null;
      },
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/appointmentList'), child: const Text('Go to Appointment List'))]),
      ),
    );
  }
}

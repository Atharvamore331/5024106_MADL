import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) {
      // Forward errors to a monitoring service in a production application.
      debugPrint('Flutter error: ${details.exceptionAsString()}');
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Unhandled error: $error');
    debugPrintStack(stackTrace: stack);
    return true;
  };
  runApp(const ProductionApp());
}

class ProductionApp extends StatelessWidget {
  const ProductionApp({super.key});
  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (_) => const AppErrorScreen();
    return MaterialApp(
      title: 'Production Flutter App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark)),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Android App'), centerTitle: true),
      body: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.android, size: 90, color: colors.primary),
          const SizedBox(height: 24),
          Text('Your app is running!', style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text('This Flutter application is ready for Android testing.', style: textTheme.bodyLarge, textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Text('Button pressed', style: textTheme.bodyMedium),
          Text('$counter', style: textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: colors.primary)),
          const SizedBox(height: 24),
          FilledButton.icon(onPressed: () => setState(() => counter++), icon: const Icon(Icons.add), label: const Text('Test button')),
        ]),
      ))),
    );
  }
}

class AppErrorScreen extends StatelessWidget {
  const AppErrorScreen({super.key});
  @override
  Widget build(BuildContext context) => const Material(
    child: SafeArea(child: Center(child: Padding(padding: EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.error_outline, size: 70), SizedBox(height: 20),
        Text('Something went wrong', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 12), Text('Please close the application and try again.', textAlign: TextAlign.center),
      ]),
    ))),
  );
}

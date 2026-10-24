import 'package:flutter/material.dart';

void main() => runApp(const GestureNavApp());

class GestureNavApp extends StatelessWidget {
  const GestureNavApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark)),
        initialRoute: '/',
        routes: {'/': (_) => const CounterScreen(), '/details': (_) => const DetailsScreen()},
      );
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int score = 0;
  String status = 'Try tapping, double-tapping, or holding the card.';
  void notify(String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text),
      duration: const Duration(milliseconds: 900), behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Gesture Dashboard'), centerTitle: true),
        body: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(status, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () { setState(() { score++; status = 'Single tap: +1 point'; }); notify('Point added'); },
              onDoubleTap: () { setState(() { score += 5; status = 'Double tap: +5 points'; }); notify('Combo boost'); },
              onLongPress: () { setState(() { score = 0; status = 'Long press: score reset'; }); notify('Score reset'); },
              child: Container(width: double.infinity, height: 190,
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.purpleAccent, Colors.deepPurple]),
                  borderRadius: BorderRadius.circular(20)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('TOTAL SCORE', style: TextStyle(letterSpacing: 1.5)),
                  const SizedBox(height: 8),
                  Text('$score', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Tap +1  |  Double tap +5  |  Hold to reset'),
                ]),
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(onPressed: () => Navigator.of(context).pushNamed('/details', arguments: score),
              icon: const Icon(Icons.analytics_outlined), label: const Text('View summary')),
          ]),
        ))),
      );
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final score = ModalRoute.of(context)?.settings.arguments as int? ?? 0;
    return Scaffold(appBar: AppBar(title: const Text('Summary'), centerTitle: true),
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.emoji_events_outlined, size: 80, color: Colors.amber),
        const SizedBox(height: 16),
        Text('Final score: $score', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 24),
        OutlinedButton.icon(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back),
          label: const Text('Return to dashboard')),
      ])),
    );
  }
}

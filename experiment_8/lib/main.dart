import 'dart:convert';
import 'package:flutter/material.dart';

void main() => runApp(const FileDemoApp());

class FileDemoApp extends StatelessWidget {
  const FileDemoApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
    routes: {'/': (_) => const FileHomeScreen(), '/log': (_) => const LogScreen()},
  );
}

// A portable in-memory file stand-in. JSON is encoded when stored and decoded on read.
class SimulatedStorage {
  static final Map<String, String> _disk = {};
  static Future<void> save(String name, String contents) async {
    _disk[name] = jsonEncode({'timestamp': DateTime.now().toIso8601String(), 'data': contents});
  }
  static Future<String> read(String name) async {
    final raw = _disk[name];
    if (raw == null) throw const FormatException('File not found');
    return (jsonDecode(raw) as Map<String, dynamic>)['data'] as String? ?? '';
  }
  static Future<void> delete(String name) async { _disk.remove(name); }
}

class FileHomeScreen extends StatefulWidget {
  const FileHomeScreen({super.key});
  @override
  State<FileHomeScreen> createState() => _FileHomeScreenState();
}

class _FileHomeScreenState extends State<FileHomeScreen> {
  static const filename = 'user_data.json';
  final controller = TextEditingController();
  String output = 'No data loaded.';
  @override
  void dispose() { controller.dispose(); super.dispose(); }
  void message(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> save() async {
    final text = controller.text.trim();
    if (text.isEmpty) { message('Enter content before saving.'); return; }
    await SimulatedStorage.save(filename, text);
    if (!mounted) return;
    controller.clear();
    message('Data saved to simulated file.');
  }
  Future<void> read() async {
    try {
      final value = await SimulatedStorage.read(filename);
      if (mounted) setState(() => output = value);
    } on FormatException {
      if (mounted) setState(() => output = 'File does not exist or is empty.');
    }
  }
  Future<void> delete() async {
    await SimulatedStorage.delete(filename);
    if (!mounted) return;
    setState(() => output = 'No data loaded.');
    message('Simulated file deleted.');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('JSON & File Operations'), centerTitle: true),
    body: SafeArea(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
      TextField(controller: controller, decoration: const InputDecoration(labelText: 'Enter file contents', border: OutlineInputBorder())),
      const SizedBox(height: 16),
      Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
        FilledButton.icon(onPressed: save, icon: const Icon(Icons.save_alt), label: const Text('Save')),
        FilledButton.tonalIcon(onPressed: read, icon: const Icon(Icons.file_open), label: const Text('Read')),
        OutlinedButton.icon(onPressed: delete, icon: const Icon(Icons.delete_outline), label: const Text('Delete')),
      ]),
      const SizedBox(height: 24),
      Container(width: double.infinity, padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
        child: Text('File output:\n$output')),
      const Spacer(),
      TextButton(onPressed: () => Navigator.pushNamed(context, '/log'), child: const Text('Open operations log')),
    ]))),
  );
}

class LogScreen extends StatelessWidget {
  const LogScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Operations log'), centerTitle: true),
    body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('File Operations Log Screen'), const SizedBox(height: 20),
      FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Go back')),
    ])),
  );
}

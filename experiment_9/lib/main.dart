import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
void main() => runApp(const StudentDatabaseApp());

class StudentDatabaseApp extends StatelessWidget {
  const StudentDatabaseApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
    home: const StudentPage(),
  );
}

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});
  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final courseController = TextEditingController();
  String message = 'Enter student details';
  bool busy = false;
  bool get configured => supabaseUrl.startsWith('https://') && supabaseKey.isNotEmpty;

  @override
  void dispose() { idController.dispose(); nameController.dispose(); courseController.dispose(); super.dispose(); }
  Uri studentsUri([Map<String, String>? query]) =>
      Uri.parse('${supabaseUrl.replaceFirst(RegExp(r'/$'), '')}/rest/v1/students').replace(queryParameters: query);
  Map<String, String> get headers => {
    'apikey': supabaseKey,
    'Content-Type': 'application/json',
    'Prefer': 'return=representation',
  };

  Future<void> runRequest(Future<String> Function() action) async {
    if (!configured) { setState(() => message = 'Set SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY to connect.'); return; }
    setState(() => busy = true);
    try {
      final result = await action();
      if (mounted) setState(() => message = result);
    } catch (error) {
      if (mounted) setState(() => message = 'Request failed: $error');
    } finally { if (mounted) setState(() => busy = false); }
  }

  Future<String> saveStudent() async {
    final studentId = int.tryParse(idController.text.trim());
    if (studentId == null || nameController.text.trim().isEmpty || courseController.text.trim().isEmpty) {
      throw const FormatException('Enter a numeric ID, name, and course.');
    }
    final response = await http.post(studentsUri(), headers: headers, body: jsonEncode({
      'id': studentId, 'name': nameController.text.trim(), 'course': courseController.text.trim(),
    }));
    if (response.statusCode < 200 || response.statusCode >= 300) throw Exception('${response.statusCode}: ${response.body}');
    return 'Student saved.';
  }
  Future<String> readStudents() async {
    final response = await http.get(studentsUri({'select': '*', 'order': 'id.asc'}), headers: headers);
    if (response.statusCode < 200 || response.statusCode >= 300) throw Exception('${response.statusCode}: ${response.body}');
    return const JsonEncoder.withIndent('  ').convert(jsonDecode(response.body));
  }
  Future<String> deleteStudent() async {
    final studentId = int.tryParse(idController.text.trim());
    if (studentId == null) throw const FormatException('Enter a numeric student ID to delete.');
    final response = await http.delete(studentsUri({'id': 'eq.$studentId'}), headers: headers);
    if (response.statusCode < 200 || response.statusCode >= 300) throw Exception('${response.statusCode}: ${response.body}');
    return 'Delete request completed for student $studentId.';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Student Database'), centerTitle: true),
    body: SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
      TextField(controller: idController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Student ID')),
      TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Student name')),
      TextField(controller: courseController, decoration: const InputDecoration(labelText: 'Course')),
      const SizedBox(height: 16),
      Wrap(spacing: 8, runSpacing: 8, children: [
        FilledButton(onPressed: busy ? null : () => runRequest(saveStudent), child: const Text('SAVE')),
        FilledButton.tonal(onPressed: busy ? null : () => runRequest(readStudents), child: const Text('READ')),
        OutlinedButton(onPressed: busy ? null : () => runRequest(deleteStudent), child: const Text('DELETE')),
      ]),
      if (busy) const Padding(padding: EdgeInsets.all(12), child: LinearProgressIndicator()),
      const SizedBox(height: 16), SelectableText(message),
    ])),
  );
}

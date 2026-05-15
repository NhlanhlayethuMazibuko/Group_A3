import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../viewmodels/application_viewmodel.dart';

class ApplicationFormView extends StatefulWidget {
  const ApplicationFormView({super.key});

  @override
  State<ApplicationFormView> createState() => _ApplicationFormViewState();
}

class _ApplicationFormViewState extends State<ApplicationFormView> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, List<String>> modulesByLevel = {
    'First Year': [
      'Software Development I',
      'Problem Solving and Algorithms I',
      'IT Mathematics I',
    ],
    'Second Year': [
      'Software Development II',
      'Graphical User Interface Design II',
      'Technical Programming II',
    ],
    'Third Year': [
      'Software Development III',
      'Technical Programming III',
      'Communications Network III',
    ],
  };

  String? selectedYear;
  String? selectedLevel1;
  String? selectedModule1;
  String? selectedLevel2;
  String? selectedModule2;
  String? _documentUrl;
  String? _fileName;

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: true,
    );

    if (result != null) {
      final file = result.files.first;
      final bytes = file.bytes!;
      final fileName = file.name;

      final supabase = Supabase.instance.client;
      final path = '${supabase.auth.currentUser!.id}/$fileName';

      await supabase.storage.from('documents').uploadBinary(path, bytes);

      final url = supabase.storage.from('documents').getPublicUrl(path);

      setState(() {
        _documentUrl = url;
        _fileName = file.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appVM = context.watch<ApplicationViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Apply for Student Assistant")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Application Form",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 25),

                // ==================== YEAR OF STUDY ====================
                const Text(
                  "Year of Study",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: selectedYear,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select your year of study",
                  ),
                  items: ['1st Year', '2nd Year', '3rd Year']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => selectedYear = value),
                  validator: (value) =>
                      value == null ? "Year is required" : null,
                ),

                const SizedBox(height: 25),

                // ==================== MODULE 1 ====================
                const Text(
                  "Module 1",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                const Text(
                  "Academic Level",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  initialValue: selectedLevel1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select academic level",
                  ),
                  items: modulesByLevel.keys
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() {
                    selectedLevel1 = value;
                    selectedModule1 = null;
                  }),
                  validator: (value) =>
                      value == null ? "Academic level is required" : null,
                ),

                const SizedBox(height: 12),

                const Text(
                  "Module Name",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  initialValue: selectedModule1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select module",
                  ),
                  items: selectedLevel1 == null
                      ? []
                      : modulesByLevel[selectedLevel1]!
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: selectedLevel1 == null
                      ? null
                      : (value) => setState(() => selectedModule1 = value),
                  validator: (value) =>
                      value == null ? "Module is required" : null,
                ),

                const SizedBox(height: 25),

                const Text(
                  "Module 2 (Optional)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                const Text(
                  "Academic Level",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  initialValue: selectedLevel2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select academic level",
                  ),
                  items: modulesByLevel.keys
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() {
                    selectedLevel2 = value;
                    selectedModule2 = null;
                  }),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Module Name",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  initialValue: selectedModule2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select module",
                  ),
                  items: selectedLevel2 == null
                      ? []
                      : modulesByLevel[selectedLevel2]!
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: selectedLevel2 == null
                      ? null
                      : (value) => setState(() => selectedModule2 = value),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Supporting Document",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _pickDocument,
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Upload Document (PDF/DOC)"),
                  ),
                ),
                if (_fileName != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _fileName!,
                          style: const TextStyle(color: Colors.green),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 20),

                if (appVM.errorMessage != null)
                  Text(
                    appVM.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: appVM.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final navigator = Navigator.of(context);
                              final messenger = ScaffoldMessenger.of(context);

                              final success = await context
                                  .read<ApplicationViewModel>()
                                  .createApplication(
                                    year: selectedYear!,
                                    module1Level: selectedLevel1!,
                                    module1: selectedModule1!,
                                    module2Level: selectedLevel2,
                                    module2: selectedModule2,
                                    documentUrl: _documentUrl,
                                  );

                              if (!mounted) return;

                              if (success) {
                                navigator.pop();
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text("Application submitted"),
                                  ),
                                );
                              } else {
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text("Submission failed"),
                                  ),
                                );
                              }
                            }
                          },
                    child: appVM.isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Submit Application"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

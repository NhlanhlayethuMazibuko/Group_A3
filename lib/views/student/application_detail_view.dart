import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/application_model.dart';
import '../../viewmodels/application_viewmodel.dart';
import 'application_edit_view.dart';

class ApplicationDetailView extends StatelessWidget {
  final ApplicationModel application;

  const ApplicationDetailView({
    super.key,
    required this.application,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ApplicationViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Application Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Year: ${application.year}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Module 1: ${application.module1}"),
            if (application.module2 != null)
              Text("Module 2: ${application.module2}"),
            const SizedBox(height: 10),
            Text(
              "Status: ${application.status}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            if (application.status == "pending")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ApplicationEditView(application: application),
                      ),
                    );
                  },
                  child: const Text("Edit Application"),
                ),
              ),
            const SizedBox(height: 10),
            if (application.status == "pending")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _confirmDelete(context, viewModel),
                  child: const Text("Delete Application"),
                ),
              ),
            if (application.status != "pending")
              const Text(
                "This application cannot be modified",
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ApplicationViewModel viewModel,
  ) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete"),
        content:
            const Text("Are you sure you want to delete this application?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await viewModel.deleteApplication(application.id);

      navigator.pop();

      messenger.showSnackBar(
        const SnackBar(content: Text("Application deleted")),
      );
    }
  }
}

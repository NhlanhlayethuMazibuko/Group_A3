import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/application_model.dart';
import '../../viewmodels/application_viewmodel.dart';

class ApplicationEditView extends StatefulWidget {
  final ApplicationModel application;

  const ApplicationEditView({
    super.key,
    required this.application,
  });

  @override
  State<ApplicationEditView> createState() => _ApplicationEditViewState();
}

class _ApplicationEditViewState extends State<ApplicationEditView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController yearController;
  late TextEditingController module1Controller;
  late TextEditingController module2Controller;

  @override
  void initState() {
    super.initState();

    yearController = TextEditingController(text: widget.application.year);

    module1Controller = TextEditingController(text: widget.application.module1);

    module2Controller = TextEditingController(
      text: widget.application.module2 ?? "",
    );
  }

  @override
  void dispose() {
    yearController.dispose();
    module1Controller.dispose();
    module2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appVM = context.watch<ApplicationViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Application"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: yearController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Study Year",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Year is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: module1Controller,
                  decoration: const InputDecoration(
                    labelText: "Module 1",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Module 1 is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: module2Controller,
                  decoration: const InputDecoration(
                    labelText: "Module 2 (Optional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 25),
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
                              final viewModel =
                                  context.read<ApplicationViewModel>();

                              final success = await viewModel.updateApplication(
                                id: widget.application.id,
                                year: yearController.text,
                                module1: module1Controller.text,
                                module2: module2Controller.text.isEmpty
                                    ? null
                                    : module2Controller.text,
                              );

                              if (!mounted) return;

                              if (success) {
                                navigator.pop();

                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Application updated successfully",
                                    ),
                                  ),
                                );
                              } else {
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text("Update failed"),
                                  ),
                                );
                              }
                            }
                          },
                    child: appVM.isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Update Application"),
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

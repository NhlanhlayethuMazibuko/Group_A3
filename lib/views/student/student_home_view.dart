import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/application_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../widgets/application_card.dart';
import 'application_form_view.dart';
import 'application_detail_view.dart';

class StudentHomeView extends StatefulWidget {
  const StudentHomeView({super.key});

  @override
  State<StudentHomeView> createState() => _StudentHomeViewState();
}

class _StudentHomeViewState extends State<StudentHomeView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<ApplicationViewModel>().fetchApplications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Applications"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.signOut(),
          ),
        ],
      ),
      body: Consumer<ApplicationViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.applications.isEmpty) {
            return const Center(child: Text("No applications"));
          }

          return ListView.builder(
            itemCount: vm.applications.length,
            itemBuilder: (context, index) {
              final app = vm.applications[index];

              return ApplicationCard(
                application: app,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ApplicationDetailView(application: app),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ApplicationFormView()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

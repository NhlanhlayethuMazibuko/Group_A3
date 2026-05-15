import 'package:flutter/material.dart';
import '../../models/application_model.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationModel application;

  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ApplicationCard({
    super.key,
    required this.application,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        title: Text(
          "Year ${application.year}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Module 1: ${application.module1}"),
            if (application.module2 != null)
              Text("Module 2: ${application.module2}"),
            const SizedBox(height: 5),
            Text(
              "Status: ${application.status}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _statusColor(application.status),
              ),
            ),
          ],
        ),
        onTap: onTap,
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              )
            : null,
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}

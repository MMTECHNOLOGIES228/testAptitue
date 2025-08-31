import 'package:flutter/material.dart';
import '../models/project_model.dart';
import 'project_form_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;
  final VoidCallback? onDelete;
  final Function(Project)? onEdit; // Callback pour la modification

  const ProjectDetailScreen({
    super.key,
    required this.project,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (project.status) {
      case 'DRAFT':
        statusColor = Colors.grey;
        break;
      case 'PUBLISHED':
        statusColor = Colors.green;
        break;
      case 'ARCHIVED':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.blue;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        actions: [
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                // Ouvre le formulaire pour éditer
                final updatedProject = await Navigator.push<Project?>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProjectFormScreen(
                      project: project,
                      onSave: (p) {}, // onSave sera géré ci-dessous
                    ),
                  ),
                );

                // Si un projet est retourné depuis le formulaire, appelle le callback
                if (updatedProject != null && onEdit != null) {
                  onEdit!(updatedProject);
                }
              },
            ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                onDelete!();
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${project.name}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Amount: ${project.amount}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Status: ', style: TextStyle(fontSize: 18)),
                Chip(label: Text(project.status), backgroundColor: statusColor),
              ],
            ),
            const SizedBox(height: 8),
            Text('Created At: ${project.createdAt.toLocal()}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

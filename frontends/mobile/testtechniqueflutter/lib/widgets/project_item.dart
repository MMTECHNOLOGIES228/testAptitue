import 'package:flutter/material.dart';
import '../models/project_model.dart';

class ProjectItem extends StatelessWidget {
  final Project project;
  const ProjectItem({required this.project, super.key});

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    switch (project.status) {
      case 'DRAFT':
        chipColor = Colors.grey;
        break;
      case 'PUBLISHED':
        chipColor = Colors.green;
        break;
      case 'ARCHIVED':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.blue;
    }

    return ListTile(
      title: Text(project.name),
      subtitle: Text('Amount: ${project.amount.toStringAsFixed(0)}'),
      trailing: Chip(label: Text(project.status), backgroundColor: chipColor),
    );
  }
}

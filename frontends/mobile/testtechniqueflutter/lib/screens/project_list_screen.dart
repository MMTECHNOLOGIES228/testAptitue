// import 'package:flutter/material.dart';
// import '../models/project_model.dart';
// import '../services/api_service.dart';
// import 'project_detail_screen.dart';
// import 'project_form_screen.dart';

// class ProjectListScreen extends StatefulWidget {
//   const ProjectListScreen({super.key});

//   @override
//   _ProjectListScreenState createState() => _ProjectListScreenState();
// }

// class _ProjectListScreenState extends State<ProjectListScreen> {
//   final api = ApiService();
//   List<Project> projects = [];
//   bool loading = true;
//   String? token; // Stocker le JWT après login

//   @override
//   void initState() {
//     super.initState();
//     token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjYWRmMzE2Ni1kNTA4LTQ3MGMtYTFlOC05NWNjNTBiYjRiZDQiLCJlbWFpbCI6ImFkbWluQG1haWwuY29tIiwiaWF0IjoxNzU2NDY1MzgyLCJleHAiOjE3NTY0Njg5ODJ9.0Xet0a78AtBErR2Wb4WWq3gOnlz_aSOmauNFED_dX4Q"; // TODO: remplacer par login/token réel
//     loadProjects();
//   }

//   Future<void> loadProjects() async {
//     setState(() => loading = true);
//     projects = await api.getProjects();
//     setState(() => loading = false);
//   }

//   Future<void> addProject(Project project) async {
//     final newProject = await api.createProject(project, token!);
//     print("object");
//     print("object");
//     print(newProject);
//     setState(() => projects.add(newProject));
//   }

//   Future<void> editProject(Project project) async {
//     final updatedProject = await api.updateProject(project.id!, project, token!);
//     setState(() {
//       final index = projects.indexWhere((p) => p.id == project.id);
//       if (index != -1) projects[index] = updatedProject;
//     });
//   }

//   Future<void> removeProject(String id) async {
//     await api.deleteProject(id, token!);
//     setState(() => projects.removeWhere((p) => p.id == id));
//   }

//   void openFormScreen({Project? project}) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProjectFormScreen(
//           project: project,
//           onSave: project == null ? addProject : editProject,
//         ),
//       ),
//     );
//   }

//   void openDetailScreen(Project project) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProjectDetailScreen(
//           project: project,
//           onDelete: () => removeProject(project.id!),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Projects'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () => openFormScreen(),
//           ),
//         ],
//       ),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : projects.isEmpty
//           ? const Center(child: Text('No projects'))
//           : ListView.builder(
//               itemCount: projects.length,
//               itemBuilder: (context, index) {
//                 final project = projects[index];
//                 Color statusColor;
//                 switch (project.status) {
//                   case 'DRAFT':
//                     statusColor = Colors.grey;
//                     break;
//                   case 'PUBLISHED':
//                     statusColor = Colors.green;
//                     break;
//                   case 'ARCHIVED':
//                     statusColor = Colors.red;
//                     break;
//                   default:
//                     statusColor = Colors.blue;
//                 }

//                 return Card(
//                   margin: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   child: ListTile(
//                     title: Text(project.name),
//                     subtitle: Text(
//                       'Amount: ${project.amount.toStringAsFixed(0)}',
//                     ),
//                     trailing: Chip(
//                       label: Text(project.status),
//                       backgroundColor: statusColor,
//                     ),
//                     onTap: () => openDetailScreen(project),
//                     onLongPress: () => openFormScreen(project: project),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../services/api_service.dart';
import 'project_detail_screen.dart';
import 'project_form_screen.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  _ProjectListScreenState createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final api = ApiService();
  List<Project> projects = [];
  bool loading = true;
  String? token; // Stocker le JWT après login

  @override
  void initState() {
    super.initState();
    token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjYWRmMzE2Ni1kNTA4LTQ3MGMtYTFlOC05NWNjNTBiYjRiZDQiLCJlbWFpbCI6ImFkbWluQG1haWwuY29tIiwiaWF0IjoxNzU2NDY1MzgyLCJleHAiOjE3NTY0Njg5ODJ9.0Xet0a78AtBErR2Wb4WWq3gOnlz_aSOmauNFED_dX4Q"; 
    loadProjects();
  }

  Future<void> loadProjects() async {
    setState(() => loading = true);
    try {
      projects = await api.getProjects();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading projects: $e')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> addProject(Project project) async {
    try {
      final newProject = await api.createProject(project, token!);
      setState(() => projects.add(newProject));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create project: $e')),
      );
    }
  }

  Future<void> editProject(Project project) async {
    try {
      final updatedProject = await api.updateProject(project.id!, project, token!);
      setState(() {
        final index = projects.indexWhere((p) => p.id == project.id);
        if (index != -1) projects[index] = updatedProject;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update project: $e')),
      );
    }
  }

  Future<void> removeProject(String id) async {
    try {
      await api.deleteProject(id, token!);
      setState(() => projects.removeWhere((p) => p.id == id));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete project: $e')),
      );
    }
  }

  void openFormScreen({Project? project}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectFormScreen(
          project: project,
          onSave: project == null ? addProject : editProject,
        ),
      ),
    );
  }

  void openDetailScreen(Project project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailScreen(
          project: project,
          onDelete: () => removeProject(project.id!),
          onEdit: (updatedProject) => editProject(updatedProject),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => openFormScreen(),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : projects.isEmpty
              ? const Center(child: Text('No projects'))
              : ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
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

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(project.name),
                        subtitle: Text('Amount: ${project.amount.toStringAsFixed(0)}'),
                        trailing: Chip(
                          label: Text(project.status),
                          backgroundColor: statusColor,
                        ),
                        onTap: () => openDetailScreen(project),
                        onLongPress: () => openFormScreen(project: project),
                      ),
                    );
                  },
                ),
    );
  }
}

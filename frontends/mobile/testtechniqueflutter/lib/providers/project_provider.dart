import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../services/api_service.dart';

class ProjectProvider extends ChangeNotifier {
  final ApiService api;
  List<Project> projects = [];
  bool loading = true;

  ProjectProvider({required this.api});

  Future<void> loadProjects() async {
    loading = true;
    notifyListeners();
    try {
      projects = await api.getProjects();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addProject(Project project, String token) async {
    final newProject = await api.createProject(project, token);
    projects.add(newProject);
    notifyListeners();
  }

  Future<void> editProject(Project project, String token) async {
    final updatedProject = await api.updateProject(project.id!, project, token);
    final index = projects.indexWhere((p) => p.id == project.id);
    if (index != -1) projects[index] = updatedProject;
    notifyListeners();
  }

  Future<void> removeProject(String id, String token) async {
    await api.deleteProject(id, token);
    projects.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}

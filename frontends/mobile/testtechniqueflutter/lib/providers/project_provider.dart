// import 'package:flutter/material.dart';
// import '../models/project_model.dart';
// import '../services/api_service.dart';

// class ProjectProvider extends ChangeNotifier {
//   final ApiService api;
//   List<Project> projects = [];
//   bool loading = true;

//   ProjectProvider({required this.api});

//   Future<void> loadProjects() async {
//     loading = true;
//     notifyListeners();
//     try {
//       projects = await api.getProjects();
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> addProject(Project project, String token) async {
//     final newProject = await api.createProject(project, token);
//     projects.add(newProject);
//     notifyListeners();
//   }

//   Future<void> editProject(Project project, String token) async {
//     final updatedProject = await api.updateProject(project.id!, project, token);
//     final index = projects.indexWhere((p) => p.id == project.id);
//     if (index != -1) projects[index] = updatedProject;
//     notifyListeners();
//   }

//   Future<void> removeProject(String id, String token) async {
//     await api.deleteProject(id, token);
//     projects.removeWhere((p) => p.id == id);
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/project_model.dart';
import '../services/api_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ProjectProvider extends ChangeNotifier {
  final ApiService api;
  List<Project> projects = [];
  bool loading = true;

  ProjectProvider({required this.api}) {
    loadProjects();
  }

  Future<void> loadProjects() async {
    loading = true;
    notifyListeners();

    // 1 Charger depuis Hive
    var box = Hive.box<Project>('projectsBox');
    projects = box.values.toList();

    // 2 Vérifier connexion
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        final remoteProjects = await api.getProjects();
        projects = remoteProjects;

        // Mettre à jour Hive
        await box.clear();
        for (var p in projects) {
          box.put(p.id, p);
        }
      } catch (e) {
        // si l'API échoue, garder la version Hive
        debugPrint("Erreur sync API: $e");
      }
    }

    loading = false;
    notifyListeners();
  }

  Future<void> addProject(Project project, String token) async {
    var box = Hive.box<Project>('projectsBox');
    projects.add(project);
    box.put(project.id, project);
    notifyListeners();

    // Tenter de synchroniser avec API
    try {
      final created = await api.createProject(project, token);
      box.put(created.id, created); // mettre à jour Hive avec l’ID réel
      final index = projects.indexWhere((p) => p.id == project.id);
      if (index != -1) projects[index] = created;
      notifyListeners();
    } catch (_) {
      // rester offline
    }
  }

  Future<void> editProject(Project project, String token) async {
    var box = Hive.box<Project>('projectsBox');
    final index = projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      projects[index] = project;
      box.put(project.id, project);
      notifyListeners();

      // Sync API
      try {
        final updated = await api.updateProject(project.id!, project, token);
        projects[index] = updated;
        box.put(updated.id, updated);
        notifyListeners();
      } catch (_) {}
    }
  }

  Future<void> removeProject(String id, String token) async {
    var box = Hive.box<Project>('projectsBox');
    projects.removeWhere((p) => p.id == id);
    box.delete(id);
    notifyListeners();

    // Sync API
    try {
      await api.deleteProject(id, token);
    } catch (_) {}
  }
}

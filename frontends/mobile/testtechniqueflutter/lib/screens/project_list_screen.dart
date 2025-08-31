
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../models/project_model.dart';
import '../services/api_service.dart';
import '../providers/theme_provider.dart';
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
  String? token; // JWT
  late Box<Project> projectsBox;

  // Recherche et filtre
  String selectedStatus = 'ALL'; // ALL, DRAFT, PUBLISHED, ARCHIVED
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    token = "<TON_JWT>"; // Remplacer par ton token réel
    projectsBox = Hive.box<Project>('projectsBox');
    loadProjects();
  }

  // Liste filtrée selon status et recherche
  List<Project> get filteredProjects {
    return projects.where((project) {
      final matchesStatus =
          selectedStatus == 'ALL' || project.status == selectedStatus;
      final matchesSearch =
          project.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();
  }

  Future<void> loadProjects() async {
    setState(() => loading = true);

    // Charger Hive en priorité
    projects = projectsBox.values.toList();

    // Vérifier connexion
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      try {
        final remoteProjects = await api.getProjects();
        projects = remoteProjects;

        // Sauvegarder dans Hive
        await projectsBox.clear();
        for (var p in projects) projectsBox.put(p.id, p);
      } catch (e) {
        debugPrint("Erreur sync API: $e");
      }
    }

    setState(() => loading = false);
  }

  Future<void> addProject(Project project) async {
    projects.add(project);
    projectsBox.put(project.id, project);
    setState(() {});

    try {
      final created = await api.createProject(project, token!);
      projectsBox.put(created.id, created);
      final index = projects.indexWhere((p) => p.id == project.id);
      if (index != -1) projects[index] = created;
      setState(() {});
    } catch (_) {}
  }

  Future<void> editProject(Project project) async {
    final index = projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      projects[index] = project;
      projectsBox.put(project.id, project);
      setState(() {});
    }

    try {
      final updated = await api.updateProject(project.id!, project, token!);
      projects[index] = updated;
      projectsBox.put(updated.id, updated);
      setState(() {});
    } catch (_) {}
  }

  Future<void> removeProject(String id) async {
    projects.removeWhere((p) => p.id == id);
    projectsBox.delete(id);
    setState(() {});

    try {
      await api.deleteProject(id, token!);
    } catch (_) {}
  }

  void openFormScreen({Project? project}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectFormScreen(
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
        builder: (_) => ProjectDetailScreen(
          project: project,
          onDelete: () => removeProject(project.id!),
          onEdit: (updatedProject) => editProject(updatedProject),
        ),
      ),
    );
  }

  Widget buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Dropdown pour le statut
          DropdownButton<String>(
            value: selectedStatus,
            items: ['ALL', 'DRAFT', 'PUBLISHED', 'ARCHIVED']
                .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => selectedStatus = value);
              }
            },
          ),
          const SizedBox(width: 16),
          // Champ de recherche
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Rechercher...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => openFormScreen(),
          ),
          IconButton(
            icon: Icon(themeProvider.isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => themeProvider.toggleTheme(),
          )
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                buildFilterBar(),
                Expanded(
                  child: filteredProjects.isEmpty
                      ? const Center(child: Text('Aucun projet'))
                      : ListView.builder(
                          itemCount: filteredProjects.length,
                          itemBuilder: (context, index) {
                            final project = filteredProjects[index];
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
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: ListTile(
                                title: Text(project.name),
                                subtitle: Text(
                                    'Amount: ${project.amount.toStringAsFixed(0)}'),
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
                ),
              ],
            ),
    );
  }
}



import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project_model.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.117:9000';

  // ---------------- GET LIST ----------------
  Future<List<Project>> getProjects({String? status, String? q}) async {
    var query = '';
    if (status != null) query += 'status=$status&';
    if (q != null) query += 'q=$q&';

    final res = await http.get(Uri.parse('$baseUrl/projects?$query'));
    if (res.statusCode == 200) {
      return (json.decode(res.body) as List)
          .map((e) => Project.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  // ---------------- CREATE ----------------
  Future<Project> createProject(Project project, String token) async {
    // On n’envoie que les champs autorisés
    final body = json.encode({
      'name': project.name,
      'status': project.status,
      'amount': project.amount,
    });

    final res = await http.post(
      Uri.parse('$baseUrl/projects'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (res.statusCode == 201 || res.statusCode == 200) {
      return Project.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to create project: ${res.body}');
    }
  }

  // ---------------- UPDATE ----------------
  Future<Project> updateProject(String id, Project project, String token) async {
    final body = json.encode({
      'name': project.name,
      'status': project.status,
      'amount': project.amount,
    });

    final res = await http.put(
      Uri.parse('$baseUrl/projects/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (res.statusCode == 200) {
      return Project.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to update project');
    }
  }

  // ---------------- DELETE ----------------
  Future<void> deleteProject(String id, String token) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/projects/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to delete project');
    }
  }
}

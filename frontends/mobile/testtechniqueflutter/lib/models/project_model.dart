// To parse this JSON data, do
//
//     final project = projectFromJson(jsonString);

import 'dart:convert';

List<Project> projectFromJson(String str) => List<Project>.from(json.decode(str).map((x) => Project.fromJson(x)));

String projectToJson(List<Project> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Project {
    final String? id;
    final String name;
    final String status;
    final int amount;
    final DateTime createdAt;

    Project({
        required this.id,
        required this.name,
        required this.status,
        required this.amount,
        required this.createdAt,
    });

    Project copyWith({
        String? id,
        String? name,
        String? status,
        int? amount,
        DateTime? createdAt,
    }) => 
        Project(
            id: id ?? this.id,
            name: name ?? this.name,
            status: status ?? this.status,
            amount: amount ?? this.amount,
            createdAt: createdAt ?? this.createdAt,
        );

    factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        amount: json["amount"],
        createdAt: DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "amount": amount,
        "createdAt": createdAt.toIso8601String(),
    };
}

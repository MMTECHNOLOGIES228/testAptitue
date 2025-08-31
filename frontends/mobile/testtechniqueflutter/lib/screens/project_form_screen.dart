import 'package:flutter/material.dart';
import '../models/project_model.dart';

class ProjectFormScreen extends StatefulWidget {
  final Project? project;
  final Function(Project) onSave;

  const ProjectFormScreen({super.key, this.project, required this.onSave});

  @override
  _ProjectFormScreenState createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  String _status = 'DRAFT';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name ?? '');
    _amountController = TextEditingController(text: widget.project?.amount.toString() ?? '');
    _status = widget.project?.status ?? 'DRAFT';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final project = Project(
        id: widget.project?.id ?? '',
        name: _nameController.text,
        status: _status,
        amount: int.parse(_amountController.text),
        createdAt: widget.project?.createdAt ?? DateTime.now(),
      );
      widget.onSave(project);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.project == null ? 'Ajouter Project' : 'Modifier Project')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (val) => val == null || val.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || double.tryParse(val) == null ? 'Nombre valide requis' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                items: ['DRAFT', 'PUBLISHED', 'ARCHIVED']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _status = val!),
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _submit, child: Text(widget.project == null ? 'Ajouter' : 'Modifier')),
            ],
          ),
        ),
      ),
    );
  }
}

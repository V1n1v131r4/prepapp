import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  List<Map<String, dynamic>> _checklists = [];
  final TextEditingController _newChecklistController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadChecklists();
  }

  Future<void> _loadChecklists() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('checklists');
    if (savedData != null) {
      setState(() {
        _checklists = List<Map<String, dynamic>>.from(json.decode(savedData));
      });
    }
  }

  Future<void> _saveChecklists() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('checklists', json.encode(_checklists));
  }

  void _addChecklist() {
    if (_newChecklistController.text.isEmpty) return;
    setState(() {
      _checklists.add({
        'title': _newChecklistController.text,
        'items': []
      });
      _newChecklistController.clear();
    });
    _saveChecklists();
  }

  void _addItemToChecklist(int index, String item) {
    setState(() {
      _checklists[index]['items'].add({'text': item, 'checked': false});
    });
    _saveChecklists();
  }

  void _toggleItem(int checklistIndex, int itemIndex) {
    setState(() {
      _checklists[checklistIndex]['items'][itemIndex]['checked'] = 
          !_checklists[checklistIndex]['items'][itemIndex]['checked'];
    });
    _saveChecklists();
  }

  void _deleteChecklist(int index) {
    setState(() {
      _checklists.removeAt(index);
    });
    _saveChecklists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Checklists"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newChecklistController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Novo checklist...",
                      hintStyle: TextStyle(color: Colors.white60),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: _addChecklist,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _checklists.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.grey[850],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    title: Text(
                      _checklists[index]['title'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    children: [
                      for (int i = 0; i < _checklists[index]['items'].length; i++)
                        CheckboxListTile(
                          title: Text(
                            _checklists[index]['items'][i]['text'],
                            style: TextStyle(
                              color: _checklists[index]['items'][i]['checked'] ? Colors.grey : Colors.white,
                              decoration: _checklists[index]['items'][i]['checked']
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          value: _checklists[index]['items'][i]['checked'],
                          onChanged: (_) => _toggleItem(index, i),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onSubmitted: (value) => _addItemToChecklist(index, value),
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: "Adicionar item...",
                                  hintStyle: TextStyle(color: Colors.white60),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => _deleteChecklist(index),
                        child: const Text("Excluir Checklist", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/note_controller.dart';
import '../../../model/note/note.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;
  const NoteEditorScreen({super.key, this.note});

  @override
  NoteEditorScreenState createState() => NoteEditorScreenState();
}

class NoteEditorScreenState extends State<NoteEditorScreen> {
  final NoteController noteController = Get.find<NoteController>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  late String selectedCategory;
  late bool isPinned;
  late List<bool> checklistItems;

  static const List<String> defaultCategories = ['General', 'Work', 'Personal', 'Ideas'];

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.note?.category ?? 'General';
    isPinned = widget.note?.isPinned ?? false;
    checklistItems = List.from(widget.note?.checklist ?? []);
    
    titleController.text = widget.note?.title ?? '';
    contentController.text = widget.note?.content ?? '';
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined),
            onPressed: () => setState(() => isPinned = !isPinned),
          ),
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                noteController.deleteNote(widget.note!.id);
                Get.back();
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 10),
            TextField(controller: contentController, decoration: const InputDecoration(labelText: 'Content'), maxLines: null),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedCategory,
              items: (defaultCategories.contains(selectedCategory) ? defaultCategories : [...defaultCategories, selectedCategory])
                  .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                  .toList(),
              onChanged: (value) => setState(() => selectedCategory = value!),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveNote,
        child: const Icon(Icons.save),
      ),
    );
  }

  void _saveNote() {
    final title = titleController.text.trim();
    final content = contentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      Get.snackbar('Error', 'Both title and content are required.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (widget.note == null) {
      noteController.addNote(title, content, selectedCategory, isPinned, checklistItems);
    } else {
      noteController.editNote(widget.note!.id, title, content, selectedCategory, isPinned, checklistItems);
    }
    Get.back();
  }
}

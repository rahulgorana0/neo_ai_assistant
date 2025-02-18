import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neo_ai_assistant/model/note/note.dart';
import '../../../controller/note_controller.dart';
import 'note_editor_feature.dart';

class NoteFeature extends StatelessWidget {
  final NoteController noteController = Get.find<NoteController>();

  NoteFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          Obx(() => IconButton(
                icon: Icon(noteController.isGridView.value
                    ? Icons.view_list
                    : Icons.grid_view),
                onPressed: noteController.toggleViewMode,
              )),
        ],
      ),
      body: Obx(() {
        final notes = noteController.filteredNotes;
        return notes.isEmpty
            ? const Center(child: Text('No notes yet!'))
            : AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: noteController.isGridView.value
                    ? GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        key: ValueKey(noteController.isGridView.value),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: notes.length,
                        itemBuilder: (context, index) => _buildNoteCard(notes[index], context),
                      )
                    : ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) => _buildNoteCard(notes[index], context),
                      ),
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const NoteEditorScreen()),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNoteCard(Note note, BuildContext context) {
    return GestureDetector(
      key: ValueKey(note.id),
      onTap: () => Get.to(() => NoteEditorScreen(note: note)),
      child: Card(
        elevation: 3,
        child: ListTile(
          title: Text(note.title, maxLines: 5, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            note.content.split('\n').first,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(note.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
                onPressed: () => noteController.togglePin(note.id),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => noteController.deleteNote(note.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

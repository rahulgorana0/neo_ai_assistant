import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../model/note/note.dart';

class NoteController extends GetxController {
  late Box<Note> noteBox;
  final notes = <Note>[].obs;
  final filteredNotes = <Note>[].obs;
  var searchQuery = ''.obs;
  var isGridView = true.obs;
  final List<String> categories = ['General', 'Work', 'Personal', 'Ideas'];

  @override
  void onInit() {
    super.onInit();
    _initializeHive();
    debounce(notes, (_) => _sortAndFilterNotes(), time: const Duration(milliseconds: 300));
  }

  Future<void> _initializeHive() async {
    noteBox = await Hive.openBox<Note>('notes');
    notes.assignAll(noteBox.values.toList());
    _sortAndFilterNotes();
  }

  void addNote(String title, String content, String category, bool isPinned, List<bool> checklist) {
    final newNote = Note(
      id: const Uuid().v4(),
      title: title,
      content: content,
      category: category,
      isPinned: isPinned,
      checklist: checklist,
      timestamp: DateTime.now(),
    );

    noteBox.put(newNote.id, newNote);
    notes.add(newNote);
    _sortAndFilterNotes();
  }

  void editNote(String id, String title, String content, String category, bool isPinned, List<bool> checklist) {
    final index = notes.indexWhere((note) => note.id == id);
    if (index == -1) return;

    final updatedNote = notes[index].copyWith(
      title: title,
      content: content,
      category: category,
      isPinned: isPinned,
      checklist: checklist,
      timestamp: DateTime.now(),
    );

    noteBox.put(id, updatedNote);
    notes[index] = updatedNote;
    _sortAndFilterNotes();
  }

  void deleteNote(String id) {
    noteBox.delete(id);
    notes.removeWhere((note) => note.id == id);
    _sortAndFilterNotes();
  }

  void togglePin(String id) {
    final index = notes.indexWhere((note) => note.id == id);
    if (index == -1) return;

    final updatedNote = notes[index].copyWith(isPinned: !notes[index].isPinned);
    noteBox.put(id, updatedNote);
    notes[index] = updatedNote;
    _sortAndFilterNotes();
  }

  void _sortAndFilterNotes() {
    if (notes.isEmpty) {
      filteredNotes.clear();
      return;
    }

    final query = searchQuery.value.trim().toLowerCase();
    List<Note> sortedNotes = notes.where((note) {
      return query.isEmpty ||
          note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);
    }).toList();

    sortedNotes.sort((a, b) {
      if (a.isPinned == b.isPinned) {
        return b.timestamp.compareTo(a.timestamp);
      }
      return a.isPinned ? -1 : 1;
    });

    filteredNotes.assignAll(sortedNotes);
  }

  void searchNotes(String query) {
    searchQuery.value = query;
    _sortAndFilterNotes();
  }

  void toggleViewMode() {
    isGridView.toggle();
  }
}

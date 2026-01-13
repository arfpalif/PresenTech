import 'package:get/get.dart';
import 'package:presentech/features/hrd/tasks/repositories/hrd_task_repository.dart';
import 'package:presentech/shared/models/tasks.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/shared/view/components/snackbar/success_snackbar.dart';

class HrdTaskController extends GetxController {
  //repository
  final taskRepo = HrdTaskRepository();

  RxList<Tasks> tasks = <Tasks>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      isLoading.value = true;
      final response = await taskRepo.fetchTasks();
      tasks.value = response.map<Tasks>((item) => Tasks.fromMap(item)).toList();
    } catch (e) {
      print("Error fetchTasks: $e");
      FailedSnackbar.show("Gagal mengambil data tugas: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> insertTask(Tasks task) async {
    try {
      await taskRepo.insertTask(task);
      await fetchTasks();
      return true;
    } catch (e) {
      print("Error insertTask: $e");
      FailedSnackbar.show("Gagal menambahkan tugas: ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateTask(Tasks task) async {
    try {
      await taskRepo.updateTask(task);
      await fetchTasks();
      return true;
    } catch (e) {
      print("Error updateTask: $e");
      FailedSnackbar.show("Gagal memperbarui tugas: ${e.toString()}");
      return false;
    }
  }

  Future<bool> deleteTask(int id) async {
    try {
      await taskRepo.deleteTask(id);
      tasks.removeWhere((t) => t.id == id);
      SuccessSnackbar.show("Tugas berhasil dihapus");
      return true;
    } catch (e) {
      print("Error deleteTask: $e");
      FailedSnackbar.show("Gagal menghapus tugas: ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateTaskStatus(int id, String status) async {
    try {
      await taskRepo.updateTaskStatus(id, status);
      await fetchTasks();
      return true;
    } catch (e) {
      print("Error updateTaskStatus: $e");
      return false;
    }
  }
}

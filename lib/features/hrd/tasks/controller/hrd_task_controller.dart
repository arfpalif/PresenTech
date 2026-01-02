import 'package:get/get.dart';
import 'package:presentech/features/hrd/tasks/repositories/hrd_task_repository.dart';
import 'package:presentech/shared/models/tasks.dart';

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
      Get.snackbar("Error", "Gagal mengambil data tugas: ${e.toString()}");
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
      Get.snackbar("Error", "Gagal menambahkan tugas: ${e.toString()}");
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
      Get.snackbar("Error", "Gagal memperbarui tugas: ${e.toString()}");
      return false;
    }
  }

  Future<bool> deleteTask(int id) async {
    try {
      await taskRepo.deleteTask(id);
      tasks.removeWhere((t) => t.id == id);
      Get.snackbar("Berhasil", "Tugas berhasil dihapus");
      return true;
    } catch (e) {
      print("Error deleteTask: $e");
      Get.snackbar("Error", "Gagal menghapus tugas: ${e.toString()}");
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

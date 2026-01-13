import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomepageRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getUserOffice(session, userId) async {
    try {
      final user = await supabase
          .from(ApiConstant.tableUsers)
          .select("office_id")
          .eq("id", userId)
          .maybeSingle();

      return user;
    } catch (e) {
      FailedSnackbar.show("User tidak termasuk dalam office apapun");
      throw Exception("User dont have office");
    }
  }

  Future<Map<String, dynamic>?> getOfficeDetails(officeId) async {
    try {
      final office = await supabase
          .from(ApiConstant.tableOffices)
          .select()
          .eq("id", officeId)
          .maybeSingle();

      return office;
    } catch (e) {
      FailedSnackbar.show("Tidak ada office");
      throw Exception("Error");
    }
  }

  Future<Map<String, dynamic>?> getUser(session, userId) async {
    try {
      final response = await supabase
          .from(ApiConstant.tableUsers)
          .select('name, profile_picture, role')
          .eq("id", userId)
          .maybeSingle();

      return response;
    } catch (e) {
      FailedSnackbar.show("Failed to fetch user data");
      throw Exception("Error");
    }
  }
}

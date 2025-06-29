import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/schools/data/models/school_m.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SchoolRemoteDataSource {
  Future<List<SchoolModel>> fetchAllSchools();
  Future<SchoolModel> addSchool(SchoolModel school);
  Future<void> deleteSchool(int id);
  Future<SchoolModel> updateSchool(SchoolModel school);
}

class SchoolRemoteDataSourceImpl implements SchoolRemoteDataSource {
  SupabaseClient supabaseClient = Supabase.instance.client;

  @override
  Future<List<SchoolModel>> fetchAllSchools() async {
    try {
      final response = await supabaseClient.from('schools').select();
      return response.map((json) => SchoolModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<SchoolModel> addSchool(SchoolModel school) async {
    try {
      final response = await supabaseClient.from('schools').insert(school.toJson()).select().single();
      return SchoolModel.fromJson(response);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteSchool(int id) async {
    try {
      await supabaseClient.from('schools').delete().eq('id', id);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<SchoolModel> updateSchool(SchoolModel school) async {
    try {
      final response = await supabaseClient.from('schools').update(school.toJson()).eq('id', school.id).select().single();
      return SchoolModel.fromJson(response);
    } catch (e) {
      throw ServerException();
    }
  }
}

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/generation_job_model.dart';

class GenerationLocalDatasource {
  late final Box<String> _box;

  Future<void> init() async {
    _box = await Hive.openBox<String>(AppConstants.jobsBoxName);
  }

  List<GenerationJobModel> loadAll() {
    return _box.values.map((raw) {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return GenerationJobModel.fromJson(json);
    }).toList();
  }

  Future<void> save(GenerationJobModel model) async {
    await _box.put(model.id, jsonEncode(model.toJson()));
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}

import 'package:get_it/get_it.dart';

import 'features/generation/data/datasources/generation_local_datasource.dart';
import 'features/generation/data/repositories/generation_repository_impl.dart';
import 'features/generation/data/services/fake_generation_service.dart';
import 'features/generation/domain/repositories/generation_repository.dart';
import 'features/generation/domain/services/generation_service.dart';
import 'features/generation/domain/usecases/create_generation_job.dart';
import 'features/generation/domain/usecases/delete_generation_job.dart';
import 'features/generation/domain/usecases/load_saved_jobs.dart';
import 'features/generation/domain/usecases/persist_job.dart';
import 'features/generation/presentation/cubits/generation_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // -- Datasources --
  final localDatasource = GenerationLocalDatasource();
  await localDatasource.init();
  sl.registerSingleton<GenerationLocalDatasource>(localDatasource);

  // -- Services --
  sl.registerLazySingleton<GenerationService>(() => FakeGenerationService());

  // -- Repositories --
  sl.registerLazySingleton<GenerationRepository>(
    () => GenerationRepositoryImpl(sl<GenerationLocalDatasource>()),
  );

  // -- Use cases --
  sl.registerFactory(() => CreateGenerationJob(sl<GenerationRepository>()));
  sl.registerFactory(() => DeleteGenerationJob(sl<GenerationRepository>()));
  sl.registerFactory(() => LoadSavedJobs(sl<GenerationRepository>()));
  sl.registerFactory(() => PersistJob(sl<GenerationRepository>()));

  // -- Cubits --
  sl.registerFactory(
    () => GenerationCubit(
      createGenerationJob: sl<CreateGenerationJob>(),
      deleteGenerationJob: sl<DeleteGenerationJob>(),
      loadSavedJobs: sl<LoadSavedJobs>(),
      persistJob: sl<PersistJob>(),
      generationService: sl<GenerationService>(),
    ),
  );
}

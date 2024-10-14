import 'package:get_it/get_it.dart';
import 'package:plinko/feature/aspects/repository/life_aspect_repository.dart';
import 'package:plinko/feature/test/repository/test_repository.dart';
import 'package:plinko/feature/aspects/repository/user_data_repository.dart';

final locator = GetIt.instance;

void setupDependencyInjection() {
  locator.registerSingleton(UserDataRepository());
  locator.registerSingleton(TestRepository());
  locator.registerSingleton(LifeAspectRepository());
}

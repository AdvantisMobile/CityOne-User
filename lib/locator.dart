import 'package:get_it/get_it.dart';
import 'package:markets/src/services/firestore_service.dart';



GetIt locator = GetIt.instance;


void setupLocator(){
  locator.registerLazySingleton(() => firestoreService());

}
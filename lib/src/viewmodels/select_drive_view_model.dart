



import 'package:markets/src/models/vehicle.dart';
import 'package:markets/src/repository/vehicles_repository.dart';
import 'package:markets/src/viewmodels/base_model.dart';



class SelectedDriveViewModels extends BaseModel {

  List<Vehicle> vehicles = <Vehicle>[];


  Future<void> listenForVehicles() async {
    final Stream<Vehicle> stream = await getVehicles();
    stream.listen((Vehicle _vehicle) {
      if (_vehicle.role == 'driver') {
        vehicles.add(_vehicle);
        notifyListeners();
      }
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

}
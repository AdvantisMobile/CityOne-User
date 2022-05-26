
import 'dart:convert';

import 'package:markets/src/helpers/custom_trace.dart';
import 'package:markets/src/helpers/helper.dart';
import 'package:markets/src/models/vehicle.dart';
import 'package:http/http.dart' as http;

Future<Stream<Vehicle>> getVehicles() async {
  Uri uri = Helper.getUri('api/vehicles');
  //Map<String, dynamic> _queryParams = {};
 // uri = uri.replace(queryParameters: _queryParams);
  print(uri);


  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Vehicle.fromJson(data);
    });
    print(streamedRest.stream);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Vehicle.fromJson({}));
  }
}

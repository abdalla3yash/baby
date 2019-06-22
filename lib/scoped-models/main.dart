import 'package:scoped_model/scoped_model.dart';

import './connected_nurseries.dart';

class MainModel extends Model with ConnectedNurseriesModel, UserModel, NurseriesModel, UtilityModel {
}

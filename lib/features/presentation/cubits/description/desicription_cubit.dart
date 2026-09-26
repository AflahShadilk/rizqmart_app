import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit regulating the "read more/less" toggle for product descriptions.
class DesicriptionCubit extends Cubit<bool>{
  DesicriptionCubit():super(false);
  void toggle()=>emit(!state);
}
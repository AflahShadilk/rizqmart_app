import 'package:flutter_bloc/flutter_bloc.dart';
class DesicriptionCubit extends Cubit<bool>{
  DesicriptionCubit():super(false);
  void toggle()=>emit(!state);
}
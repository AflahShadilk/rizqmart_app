import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit containing simple boolean switching for a favorite/like button.
class LikeButtonCubit extends Cubit<bool>{

  LikeButtonCubit():super(false);
  void toggle()=>emit(!state);
  void set(bool value)=>emit(value);
}
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageIndexCubit extends Cubit<int>{
  ImageIndexCubit():super(0);
  void change(int index)=>emit(index);
}
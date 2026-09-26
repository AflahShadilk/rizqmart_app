import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit tracking the currently viewed image index in a product image carousel.
class ImageIndexCubit extends Cubit<int>{
  ImageIndexCubit():super(0);
  void change(int index)=>emit(index);
}
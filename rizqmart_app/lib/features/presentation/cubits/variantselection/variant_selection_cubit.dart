import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit storing the currently selected product variant (size, color) index.
class VariantSelectionCubit extends Cubit<int>{
  VariantSelectionCubit():super(0);
  void selectVariant(int index){
    emit(index);
  }

  void reset()=>emit(0);
}
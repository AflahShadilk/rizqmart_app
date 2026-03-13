import 'package:flutter_bloc/flutter_bloc.dart';
class VariantSelectionCubit extends Cubit<int>{
  VariantSelectionCubit():super(0);
  void selectVariant(int index){
    emit(index);
  }

  void reset()=>emit(0);
}
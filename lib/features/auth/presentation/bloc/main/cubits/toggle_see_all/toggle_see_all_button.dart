import 'package:flutter_bloc/flutter_bloc.dart';

class ToggleSeeAllButtonCubit extends Cubit<bool>{
ToggleSeeAllButtonCubit():super(false);

void toggle()=>emit(!state);
void showGrid()=>emit(true);
void showHorizontal()=>emit(false);
}
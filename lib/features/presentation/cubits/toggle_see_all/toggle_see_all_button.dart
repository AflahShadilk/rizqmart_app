import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit switching a list view between horizontal scroll and a full grid representation.
class ToggleSeeAllButtonCubit extends Cubit<bool>{
ToggleSeeAllButtonCubit():super(false);

void toggle()=>emit(!state);
void showGrid()=>emit(true);
void showHorizontal()=>emit(false);
}
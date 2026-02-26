import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit driving the active index of the primary bottom navigation bar.
class NavigationCubit extends Cubit<int>{
 NavigationCubit():super(0);
 void updateIndex(int index)=>emit(index);
 void get currentIndex=>state;
}
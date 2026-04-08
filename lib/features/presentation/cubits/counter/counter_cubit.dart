import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit containing simple increment/decrement logic for product quantities.
class CounterCubit extends Cubit<int>{
   CounterCubit():super(1);
   void increament(){
    if(state>=1&&state<20)emit(state+1);
   }
   void decreament(){
    if(state>1)emit(state-1);
   }
   void reset()=>emit(1);
 }
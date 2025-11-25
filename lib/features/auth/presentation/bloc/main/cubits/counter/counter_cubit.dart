import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int>{
   CounterCubit():super(1);
   void increament(){
    if(state>=1&&state<=11)emit(state+1);
   }
   void decreament(){
    if(state>1)emit(state-1);
   }
   void reset()=>emit(1);
 }
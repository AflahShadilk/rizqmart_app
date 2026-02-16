// ignore_for_file: use_super_parameters

import 'package:flutter_bloc/flutter_bloc.dart';

class DateOfBirthCubit extends Cubit<DateTime?> {
  
  DateOfBirthCubit(DateTime? initialDate) : super(initialDate);

  void setDate(DateTime? date) => emit(date);
}

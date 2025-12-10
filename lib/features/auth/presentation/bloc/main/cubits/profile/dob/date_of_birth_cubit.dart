import 'package:flutter_bloc/flutter_bloc.dart';

class DateOfBirthCubit extends Cubit<DateTime?> {
  // ignore: use_super_parameters
  DateOfBirthCubit(DateTime? initialDate) : super(initialDate);

  void setDate(DateTime? date) => emit(date);
}

import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit preserving the chosen gender string before form commits.
class GenderCubit extends Cubit<String?> {
  
  // ignore: use_super_parameters
  GenderCubit(String? initialGender) : super(initialGender);

  void setGender(String? gender) => emit(gender);
}

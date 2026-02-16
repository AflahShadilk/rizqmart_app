
import 'package:flutter_bloc/flutter_bloc.dart';
import 'welcome_state.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit() : super(const WelcomeInitial(0));

  void setPage(int page) {
    emit(WelcomePageUpdated(page));
  }
}

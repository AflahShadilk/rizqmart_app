
import 'package:flutter_bloc/flutter_bloc.dart';
import 'welcome_state.dart';

/// Cubit to handle page transitions or states within the onboarding/welcome screen.
class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit() : super(const WelcomeInitial(0));

  void setPage(int page) {
    emit(WelcomePageUpdated(page));
  }
}

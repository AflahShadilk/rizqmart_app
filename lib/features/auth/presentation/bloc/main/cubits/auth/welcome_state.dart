
import 'package:equatable/equatable.dart';

/// Base abstract class defining the onboarding pages the user is viewing.
abstract class WelcomeState extends Equatable {
  const WelcomeState();

  @override
  List<Object> get props => [];
}

class WelcomeInitial extends WelcomeState {
  final int currentPage;
  const WelcomeInitial(this.currentPage);

  @override
  List<Object> get props => [currentPage];
}

class WelcomePageUpdated extends WelcomeState {
  final int currentPage;
  const WelcomePageUpdated(this.currentPage);

  @override
  List<Object> get props => [currentPage];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'support_state.dart';

class SupportCubit extends Cubit<SupportState> {
  SupportCubit() : super(SupportInitial());

  Future<void> launchSupportEmail(String orderId) async {
    emit(SupportLaunching());
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@rizqmart.com',
      query: 'subject=Help with Order #$orderId',
    );
    final launched = await launchUrl(emailUri);
    if (launched) {
      emit(SupportLaunchSuccess());
    } else {
      emit(SupportLaunchFailure());
    }
  }
}
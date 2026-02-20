import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/delivery/delivery_partner_state.dart';

class DeliveryPartnerCubit extends Cubit<DeliveryPartnerState> {
  DeliveryPartnerCubit() : super(_generatePartner());

  static DeliveryPartnerState _generatePartner() {
    final random = Random();
    const names = [
      'Rahul Kumar',
      'Amit Singh',
      'Vikram Patel',
      'Suresh Reddy',
      'Mohd. Ali',
    ];
    return DeliveryPartnerState(
      name: names[random.nextInt(names.length)],
      avatarIndex: random.nextInt(5) + 1,
    );
  }
}

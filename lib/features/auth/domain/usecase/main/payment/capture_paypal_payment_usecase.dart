import 'package:rizqmart/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/payment_repository.dart';

class CapturePaypalPaymentUsecase {
  final PaymentRepository paymentRepository;

  CapturePaypalPaymentUsecase({required this.paymentRepository});

  Future<PaymentEntity> call(String paypalOrderId) async {
    return await paymentRepository.capturePaypalPayment(paypalOrderId);
  }
}
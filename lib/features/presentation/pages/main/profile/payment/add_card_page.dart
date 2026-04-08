import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:rizqmart/features/presentation/bloc/payment/saved_cards/saved_cards_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/payment/saved_cards/saved_cards_event.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/payment/widgets/add_card_form.dart';
import 'package:rizqmart/features/presentation/widgets/common/show_toast_actions.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';
import 'package:rizqmart/features/presentation/cubits/payment/add_card_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/payment/add_card_state.dart';

// ---------------- Add Card Page ----------------

/// A secure form page allowing users to input and save new credit or debit card details.
class AddCardPage extends StatefulWidget {
  final String userId;
  const AddCardPage({super.key, required this.userId});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {

  // ---------------- Controllers ----------------

  final CardEditController _cardEditController = CardEditController();
  final TextEditingController _nameController = TextEditingController();

  // ---------------- Dispose ----------------

  @override
  void dispose() {
    _cardEditController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // ---------------- Helper Methods ----------------

  void _validateAndSave(BuildContext context) {
    if (_nameController.text.isEmpty) {
      showToast(context, 'Please enter card holder name');
      return;
    }
    
    if (!_cardEditController.complete) {
      showToast(context, 'Please enter valid card details');
      return;
    }

    context.read<AddCardCubit>().saveCard(
      name: _nameController.text,
      userId: widget.userId,
    );
  }

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCardCubit(),
      child: ResponsiveWrapper(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add New Card'),
          ),
          body: BlocConsumer<AddCardCubit, AddCardState>(
            listener: (context, state) {
              if (state is AddCardSuccess) {
                context.read<SavedCardsBloc>().add(
                    AddSavedCardEvent(state.cardEntity, widget.userId));
                Navigator.pop(context);
              } else if (state is AddCardFailure) {
                showToast(context, 'Failed to add card: ${state.error}');
              }
            },
            builder: (context, state) {
              final isProcessing = state is AddCardLoading;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: AddCardForm(
                  nameController: _nameController,
                  cardEditController: _cardEditController,
                  isProcessing: isProcessing,
                  onSave: () => _validateAndSave(context),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

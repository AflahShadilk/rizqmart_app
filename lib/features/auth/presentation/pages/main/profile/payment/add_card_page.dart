

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/payment/saved_cards/saved_cards_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/payment/saved_cards/saved_cards_event.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/payment/add_card_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/payment/add_card_state.dart';

class AddCardPage extends StatefulWidget {
  final String userId;
  const AddCardPage({super.key, required this.userId});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final CardEditController _cardEditController = CardEditController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _cardEditController.dispose();
    _nameController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCardCubit(),
      child: ResponsiveWrapper(child: Scaffold(
        appBar: AppBar(
          title: const Text('Add New Card'),
        ),
        body: BlocConsumer<AddCardCubit, AddCardState>(
          listener: (context, state) {
            if (state is AddCardSuccess) {
              context.read<SavedCardsBloc>().add(AddSavedCardEvent(state.cardEntity, widget.userId));
              Navigator.pop(context);
            } else if (state is AddCardFailure) {
              showToast(context, 'Failed to add card: ${state.error}');
            }
          },
          builder: (context, state) {
            final isProcessing = state is AddCardLoading;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Card Holder Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  20.h,
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.cs.outline),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CardField(
                      controller: _cardEditController,
                      enablePostalCode: false,
                      style: context.isDarkMode
                          ? const TextStyle(color: Colors.white)
                          : const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Card Details',
                        hintStyle: TextStyle(color: context.cs.onSurface.withValues(alpha: 0.5)),
                      ),
                    ),
                  ),
                  40.h,
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: MainButton(
                      label: isProcessing ? 'Saving...' : 'Save Card',
                      onPress: isProcessing ? null : () => _validateAndSave(context),
                      color: context.cs.primary,
                      textColor: context.cs.surface,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      )),
    );
  }
}

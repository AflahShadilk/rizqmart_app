import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/bloc/payment/saved_cards/saved_cards_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/payment/saved_cards/saved_cards_event.dart';
import 'package:rizqmart/features/presentation/bloc/payment/saved_cards/saved_cards_state.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/payment/add_card_page.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/payment/widgets/user_card_widget.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/payment/widgets/empty_saved_cards_state.dart';
import 'package:rizqmart/features/presentation/widgets/common/show_toast_actions.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';

// ---------------- Saved Cards Page ----------------

/// A page displaying all of the user's saved payment methods, with options to add or remove them.
class SavedCardsPage extends StatefulWidget {
  const SavedCardsPage({super.key});

  @override
  State<SavedCardsPage> createState() => _SavedCardsPageState();
}

class _SavedCardsPageState extends State<SavedCardsPage> {

  // ---------------- Variables ----------------

  String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  // ---------------- Init State ----------------

  @override
  void initState() {
    super.initState();
    if (currentUserId.isNotEmpty) {
      context.read<SavedCardsBloc>().add(LoadSavedCardsEvent(currentUserId));
    }
  }

  // ---------------- Helper Methods ----------------

  void _navigateToAddCard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCardPage(userId: currentUserId),
      ),
    );
  }

  void _deleteCard(String cardId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Card'),
        content: const Text('Are you sure you want to remove this card?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SavedCardsBloc>().add(DeleteSavedCardEvent(cardId, currentUserId));
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: context.cs.error)),
          ),
        ],
      ),
    );
  }

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment Methods'),
          actions: [
            IconButton(
              onPressed: _navigateToAddCard,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: BlocConsumer<SavedCardsBloc, SavedCardsState>(
          listener: (context, state) {
            if (state is SavedCardOperationSuccess) {
              showToast(context, state.message);
            }
            if (state is SavedCardsError) {
              showToast(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is SavedCardsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SavedCardsLoaded) {
              if (state.cards.isEmpty) {
                return EmptySavedCardsState(onAddCard: _navigateToAddCard);
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.cards.length,
                itemBuilder: (context, index) {
                  final card = state.cards[index];
                  return UserCardWidget(
                    card: card,
                    onDelete: () => _deleteCard(card.id),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
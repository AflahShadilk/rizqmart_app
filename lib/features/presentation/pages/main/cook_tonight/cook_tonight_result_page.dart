import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/domain/entities/main/cook_tonight_result_entity.dart';
import 'package:rizqmart/features/presentation/bloc/main/cook_tonight/cook_tonight_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/main/cook_tonight/cook_tonight_event.dart';
import 'package:rizqmart/features/presentation/widgets/cook_tonight/cart_summary_bar.dart';
import 'package:rizqmart/features/presentation/widgets/cook_tonight/empty_result_view.dart';
import 'package:rizqmart/features/presentation/widgets/cook_tonight/ingredient_list.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/main_heading.dart';

class CookTonightResultPage extends StatelessWidget {
  final CookTonightResultEntity result;

  const CookTonightResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.surface,
      appBar: AppBar(
        backgroundColor: context.cs.surface,
        elevation: 0,
        title: const AppHeading('Your Ingredient List'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.cs.onSurface),
          onPressed: () {
            // Reset bloc state so user can search again cleanly
            context.read<CookTonightBloc>().add(const ResetCookTonightEvent());
            Navigator.of(context).pop();
          },
        ),
      ),
      body: result.ingredients.isEmpty
          ? EmptyResultView(
              onRetry: () {
                context.read<CookTonightBloc>().add(const ResetCookTonightEvent());
                Navigator.of(context).pop();
              },
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DishHeader(result: result),
                        const SizedBox(height: 20),
                        Text(
                          '${result.ingredients.length} ingredients needed',
                          style: context.ts.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.cs.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 12),
                        IngredientList(ingredients: result.ingredients),
                      ],
                    ),
                  ),
                ),
                CartSummaryBar(ingredients: result.ingredients),
              ],
            ),
    );
  }
}

class _DishHeader extends StatelessWidget {
  final CookTonightResultEntity result;

  const _DishHeader({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.cs.primaryContainer,
            context.cs.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.cs.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.restaurant_rounded,
              color: context.cs.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.dishName,
                  style: context.ts.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.cs.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'For ${result.servings} people',
                  style: context.ts.bodySmall?.copyWith(
                    color: context.cs.onPrimaryContainer.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

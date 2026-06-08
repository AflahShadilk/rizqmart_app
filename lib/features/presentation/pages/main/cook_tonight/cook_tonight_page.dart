import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/bloc/main/cook_tonight/cook_tonight_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/main/cook_tonight/cook_tonight_event.dart';
import 'package:rizqmart/features/presentation/bloc/main/cook_tonight/cook_tonight_state.dart';
import 'package:rizqmart/features/presentation/pages/main/cook_tonight/cook_tonight_result_page.dart';
import 'package:rizqmart/features/presentation/widgets/cook_tonight/ai_loading_indicator.dart';
import 'package:rizqmart/features/presentation/widgets/cook_tonight/dish_input_field.dart';
import 'package:rizqmart/features/presentation/widgets/cook_tonight/popular_dish_chips.dart';
import 'package:rizqmart/features/presentation/widgets/cook_tonight/serving_selector.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/main_heading.dart';

class CookTonightPage extends StatefulWidget {
  const CookTonightPage({super.key});

  @override
  State<CookTonightPage> createState() => _CookTonightPageState();
}

class _CookTonightPageState extends State<CookTonightPage> {
  final TextEditingController _dishController = TextEditingController();
  int _servings = 4;

  @override
  void dispose() {
    _dishController.dispose();
    super.dispose();
  }

  void _fetchIngredients(BuildContext blocContext) {
    final dish = _dishController.text.trim();
    if (dish.isEmpty) {
      ScaffoldMessenger.of(blocContext).showSnackBar(
        const SnackBar(content: Text('Please enter a dish name')),
      );
      return;
    }
    blocContext.read<CookTonightBloc>().add(
          FetchIngredientsEvent(dishName: dish, servings: _servings),
        );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: context.cs.surface,
        appBar: AppBar(
          backgroundColor: context.cs.surface,
          elevation: 0,
          title: const AppHeading('Cook Tonight'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.cs.onSurface),
            onPressed: () {
              context.read<CookTonightBloc>().add(const ResetCookTonightEvent());
              Navigator.of(context).pop();
            },
          ),
        ),
        body: BlocConsumer<CookTonightBloc, CookTonightState>(
          listener: (context, state) {
            if (state is CookTonightError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: context.cs.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
            if (state is CookTonightLoaded) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CookTonightResultPage(result: state.result),
                ),
              );
            }
          },
          builder: (blocContext, state) {
            if (state is CookTonightLoading) {
              return const AiLoadingIndicator();
            }
            return _SearchView(
              controller: _dishController,
              servings: _servings,
              onServingsChanged: (v) => setState(() => _servings = v),
              onSubmit: () => _fetchIngredients(blocContext),
              onDishChipSelected: (dish) {
                _dishController.text = dish;
                _fetchIngredients(blocContext);
              },
            );
          },
        ),
      ),
    );
  }
}

class _SearchView extends StatelessWidget {
  final TextEditingController controller;
  final int servings;
  final ValueChanged<int> onServingsChanged;
  final VoidCallback onSubmit;
  final ValueChanged<String> onDishChipSelected;

  const _SearchView({
    required this.controller,
    required this.servings,
    required this.onServingsChanged,
    required this.onSubmit,
    required this.onDishChipSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroBanner(),
          const SizedBox(height: 24),
          Text(
            "What's for dinner?",
            style: context.ts.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.cs.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 10),
          DishInputField(controller: controller, onSubmitted: onSubmit),
          const SizedBox(height: 24),
          Text(
            'Servings',
            style: context.ts.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.cs.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 10),
          ServingSelector(
            initialValue: servings,
            onChanged: onServingsChanged,
          ),
          const SizedBox(height: 28),
          Text(
            'Popular Dishes',
            style: context.ts.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.cs.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 10),
          PopularDishChips(onDishSelected: onDishChipSelected),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: onSubmit,
              icon: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.white, Colors.white70],
                ).createShader(bounds),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              label: const Text(
                'Get Ingredients',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.cs.primary,
                foregroundColor: context.cs.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.cs.primary,
            context.cs.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cook Tonight 🍳',
                  style: context.ts.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Enter any dish and we\'ll build your grocery list with AI.',
                  style: context.ts.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.auto_awesome_rounded,
            size: 48,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ],
      ),
    );
  }
}

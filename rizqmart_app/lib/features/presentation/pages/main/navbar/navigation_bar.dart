import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/presentation/cubits/navigation/navigation_cubit.dart';
import 'package:rizqmart/features/presentation/pages/main/navbar/widgets/bottom_navigation_bar_widget.dart';
import 'package:rizqmart/features/presentation/pages/main/navbar/widgets/page_container.dart';

class NavigationBarPage extends StatelessWidget {
  const NavigationBarPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, selectedIndex) {
          return ScaffoldMessenger(
            child: Scaffold(
              extendBody: true,
              body: PageContainer(selectedIndex: selectedIndex),
              bottomNavigationBar: BottomNavigationBarWidget(selectedIndex: selectedIndex),
            ),
          );
        },
      ),
    );
  }
}
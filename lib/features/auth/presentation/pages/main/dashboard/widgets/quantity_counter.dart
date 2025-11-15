// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/counter/counter_cubit.dart';

Widget buildQuantityButton(ColorScheme colorScheme) {
    return BlocBuilder<CounterCubit,int>(builder: (context,state){
      return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              context.read<CounterCubit>().decreament();
            },
            icon: Icon(Icons.remove, color: colorScheme.primary, size: 20),
            splashRadius: 20,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "$state",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
          ),
          IconButton(
            onPressed: () =>context.read<CounterCubit>().increament(),
            icon: Icon(Icons.add, color: colorScheme.primary, size: 20),
            splashRadius: 20,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          ),
        ],
      ),
    );
    });
  }
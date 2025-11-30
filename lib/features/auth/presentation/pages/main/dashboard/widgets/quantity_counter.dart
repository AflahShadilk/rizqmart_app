// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/counter/counter_cubit.dart';

Widget quantityButton(ColorScheme colorScheme) {
    return BlocBuilder<CounterCubit,int>(builder: (context,state){
      return Container(
      decoration: BoxDecoration(
        
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              context.read<CounterCubit>().decreament();
            },
            icon: Icon(Icons.remove, color: colorScheme.primary.withOpacity(0.5), size: 25),
            splashRadius: 10,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          ),
        
          Container(
            decoration: BoxDecoration(
              border: Border.all(
          color: colorScheme.primary.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.fromLTRB(15,5,15,5),
            child: Text(
              "$state",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
          ),
   
          IconButton(
            onPressed: () =>context.read<CounterCubit>().increament(),
            icon: Icon(Icons.add_rounded, color: context.cs.success, size: 25,),
            splashRadius: 10,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          ),
        ],
      ),
    );
    });
  }
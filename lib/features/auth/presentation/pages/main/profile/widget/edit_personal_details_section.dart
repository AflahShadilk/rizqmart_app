import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/dob/date_of_birth_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/gender/gender_cubit.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/widget/date_of_birth_field.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/widget/genden/gender_selection.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
class EditPersonalDetailsSection extends StatelessWidget {
  final DateOfBirthCubit dateOfBirthCubit;
  final GenderCubit genderCubit;

  const EditPersonalDetailsSection({
    super.key,
    required this.dateOfBirthCubit,
    required this.genderCubit,
  });
Widget _buildSectionTitle(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: context.ts.labelLarge?.copyWith(
          color: context.cs.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 13,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
@override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionTitle(context, 'Personal Details'),
        14.h,
        BlocBuilder<DateOfBirthCubit, DateTime?>(
          bloc: dateOfBirthCubit,
          builder: (context, selectedDate) {
            return DateOfBirthField(
              selectedDate: selectedDate,
              enabled: true,
              onDateSelected: (date) {
                dateOfBirthCubit.setDate(date);
              },
            );
          },
        ),
        12.h,
        BlocBuilder<GenderCubit, String?>(
          bloc: genderCubit,
          builder: (context, selectedGender) {
            return GenderSelector(
              selectedGender: selectedGender,
              enabled: true,
              onGenderSelected: (gender) {
                genderCubit.setGender(gender);
              },
            );
          },
        ),
      ],
    );
  }
}

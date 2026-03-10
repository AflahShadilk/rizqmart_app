import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/image/image_index_cubit.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';

class ProductImageGallery extends StatelessWidget {
  final List<String> images;
  final bool isDark;
  final ColorScheme colorScheme;
  final double? height;

  const ProductImageGallery({
    super.key,
    required this.images,
    required this.isDark,
    required this.colorScheme,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<ImageIndexCubit, int>(
          builder: (context, state) {
            return PageView.builder(
              onPageChanged: (value) {
                context.read<ImageIndexCubit>().change(value);
              },
              itemCount: images.length,
              itemBuilder: (context, index) {
                return ProductImage(
                  imageUrl: images[index],
                  height: height ?? 350,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(12),
                );
              },
            );
          },
        ),
        Positioned(
          bottom: 15,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (index) => BlocBuilder<ImageIndexCubit, int>(
                builder: (context, state) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: state == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: state == index
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

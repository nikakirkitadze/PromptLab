import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/generation/presentation/cubits/generation_cubit.dart';
import 'features/generation/presentation/pages/generation_page.dart';
import 'injection_container.dart';

class PromptLabApp extends StatelessWidget {
  const PromptLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PromptLab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: BlocProvider(
        create: (_) => sl<GenerationCubit>(),
        child: const GenerationPage(),
      ),
    );
  }
}

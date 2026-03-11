import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubits/generation_cubit.dart';
import '../cubits/generation_state.dart';
import '../widgets/generate_button.dart';
import '../widgets/generation_type_selector.dart';
import '../widgets/job_list_section.dart';
import '../widgets/prompt_input_card.dart';

class GenerationPage extends StatefulWidget {
  const GenerationPage({super.key});

  @override
  State<GenerationPage> createState() => _GenerationPageState();
}

class _GenerationPageState extends State<GenerationPage> {
  final _promptController = TextEditingController();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: BlocBuilder<GenerationCubit, GenerationState>(
            builder: (context, state) {
              if (!state.isInitialized) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.black),
                );
              }

              return CustomScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  // Header
                  SliverToBoxAdapter(child: _AppHeader()),

                  // Input section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: _InputSection(
                        promptController: _promptController,
                        state: state,
                        cubit: context.read<GenerationCubit>(),
                      ),
                    ),
                  ),

                  // Divider
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24, 28, 24, 24),
                      child: Divider(height: 0.5),
                    ),
                  ),

                  // Jobs section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                      child: JobListSection(
                        jobs: state.jobCards,
                        onCancel: context.read<GenerationCubit>().onCancelPressed,
                        onRetry: context.read<GenerationCubit>().onRetryPressed,
                        onDelete: context.read<GenerationCubit>().onDeletePressed,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _AppHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppConstants.appTitle,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.cardFill,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 20,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _InputSection extends StatelessWidget {
  final TextEditingController promptController;
  final GenerationState state;
  final GenerationCubit cubit;

  const _InputSection({
    required this.promptController,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PromptInputCard(
          controller: promptController,
          errorText: state.promptError,
          onChanged: cubit.onPromptChanged,
        ),
        const SizedBox(height: 16),
        GenerationTypeSelector(
          selected: state.selectedType,
          onChanged: cubit.onGenerationTypeChanged,
        ),
        const SizedBox(height: 20),
        GenerateButton(
          enabled: state.canGenerate,
          onPressed: cubit.onGeneratePressed,
        ),
      ],
    );
  }
}

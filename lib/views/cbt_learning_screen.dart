import 'package:flutter/material.dart';
import 'package:tawazon/services/firebase_service.dart';

class CbtLearningScreen extends StatefulWidget {
  final bool isEmbedded;
  const CbtLearningScreen({super.key, this.isEmbedded = false});

  @override
  State<CbtLearningScreen> createState() => _CbtLearningScreenState();
}

class _CbtLearningScreenState extends State<CbtLearningScreen> {
  final Set<int> _completedLessons = {};
  bool _isLoadingProgress = true;

  final List<Map<String, String>> _lessons = [
    {
      'title': 'Identifying Cognitive Distortions',
      'description': 'Learn to recognize common patterns of unhelpful thinking.',
      'content': 'Cognitive distortions are biased ways of thinking that aren\'t supported by real evidence. They are automatic thoughts that feel completely true, but are actually distorted lenses.\n\nCommon examples include:\n• All-or-Nothing Thinking: Viewing things in black-and-white (e.g., "If I make one mistake, I am a failure").\n• Catastrophizing: Expecting the worst possible outcome (e.g., "My heart is beating fast, I must be having a medical emergency").\n• Mind Reading: Assuming you know what others are thinking (e.g., "They think I am incompetent").\n\nBy practicing awareness, you can learn to notice these thoughts as they arise. Keep a log of your automatic thoughts and identify which distortion category they fall into. Recognizing them is the first and most critical step in cognitive behavioral therapy (CBT).'
    },
    {
      'title': 'Thought Challenging',
      'description': 'Discover how to challenge and replace negative automatic thoughts.',
      'content': 'Once you identify a cognitive distortion, the next step is to challenge it. Thought challenging is not about forcing positive thinking; it is about seeking realistic, evidence-based perspectives.\n\nUse the Decatastrophizing technique by asking yourself three key questions:\n1. What is the absolute worst thing that could happen, and how would I handle it?\n2. What is the absolute best thing that could happen?\n3. What is the most realistic or likely outcome?\n\nBy exploring these questions, you train your brain to break free from the cycle of fear and view situations with objectivity. Write down your realistic outcomes to reinforce this balanced thinking.'
    },
    {
      'title': 'Behavioral Activation',
      'description': 'Boost your mood by scheduling positive and meaningful actions.',
      'content': 'Behavioral activation is a core CBT skill focused on breaking the cycle of low energy and isolation. When we feel anxious or low, we tend to withdraw from activities, which further decreases our mood and energy.\n\nTo counter this, schedule small, manageable activities that bring you either a sense of Pleasure (enjoyment) or a sense of Mastery (accomplishment).\n\n• Mastery tasks: include cleaning a desk, paying a bill, or reading a chapter.\n• Pleasure tasks: include walking in nature, calling a friend, or listening to music.\n\nStart small: even a 5-minute task can break the cycle of inertia and restore your balance.'
    },
    {
      'title': 'Mindfulness and Acceptance',
      'description': 'Practice observing thoughts without judgment to reduce emotional overwhelm.',
      'content': 'Mindfulness and acceptance teach us to change our relationship with our thoughts. Instead of struggling to suppress negative feelings or fighting against them, we practice observing them non-judgmentally.\n\nAcceptance does not mean giving up or liking the pain; it means acknowledging the reality of the present moment so that you can choose how to respond. When an uncomfortable emotion arises, label it (e.g., "Here is anxiety") and breathe through it. Imagine your thoughts as clouds floating across the sky—visible, but constantly moving and passing away.'
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadCbtProgress();
  }

  Future<void> _loadCbtProgress() async {
    try {
      final completed = await FirebaseService().getCompletedLessons();
      if (mounted) {
        setState(() {
          _completedLessons.clear();
          _completedLessons.addAll(completed);
          _isLoadingProgress = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProgress = false;
        });
      }
    }
  }

  void _toggleLessonCompletion(int index) async {
    final willComplete = !_completedLessons.contains(index);
    setState(() {
      if (willComplete) {
        _completedLessons.add(index);
      } else {
        _completedLessons.remove(index);
      }
    });

    try {
      await FirebaseService().saveCbtProgress(index, willComplete);
    } catch (e) {
      // Revert if error
      setState(() {
        if (willComplete) {
          _completedLessons.remove(index);
        } else {
          _completedLessons.add(index);
        }
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sync lesson progress: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showLessonBottomSheet(BuildContext context, int index) {
    final lesson = _lessons[index];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final theme = Theme.of(context);
            final currentIsCompleted = _completedLessons.contains(index);

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.75,
              maxChildSize: 0.9,
              minChildSize: 0.5,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Handle bar
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      // Lesson Title
                      Text(
                        lesson['title']!,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E3A59),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Lesson Content (Scrollable)
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            Text(
                              lesson['content']!,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: const Color(0xFF2E3A59).withOpacity(0.85),
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 24.0),
                          ],
                        ),
                      ),

                      // Complete Button
                      ElevatedButton(
                        onPressed: () {
                          // Toggle completion state
                          _toggleLessonCompletion(index);
                          // Sync modal state
                          setModalState(() {});
                          // Sync parent view state
                          setState(() {});
                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                currentIsCompleted
                                    ? 'Lesson marked incomplete'
                                    : 'Congratulations! Lesson completed 🌟',
                              ),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: currentIsCompleted ? Colors.grey.shade300 : theme.colorScheme.primary,
                          foregroundColor: currentIsCompleted ? const Color(0xFF2E3A59) : Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: Text(currentIsCompleted ? 'Mark as Incomplete' : 'Mark as Completed'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProgress) {
      const loadingWidget = Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4DB6AC)),
          ),
        ),
      );
      if (widget.isEmbedded) {
        return loadingWidget;
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text('CBT Cognitive Lessons'),
        ),
        body: loadingWidget,
      );
    }

    final theme = Theme.of(context);
    final completionCount = _completedLessons.length;
    final progress = completionCount / _lessons.length;

    // Badges: Bronze (1+), Silver (3+), Gold (4)
    final hasBronze = completionCount >= 1;
    final hasSilver = completionCount >= 3;
    final hasGold = completionCount == 4;

    final content = SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Badge Tracker
            const Text(
              'Your Badges',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3A59),
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBadgeWidget(
                  badge: '🏅 Bronze',
                  label: 'Self-Care Starter',
                  isActive: hasBronze,
                  theme: theme,
                ),
                _buildBadgeWidget(
                  badge: '🥈 Silver',
                  label: 'Cognitive Explorer',
                  isActive: hasSilver,
                  theme: theme,
                ),
                _buildBadgeWidget(
                  badge: '🥇 Gold',
                  label: 'Mind Master',
                  isActive: hasGold,
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 32.0),

            // Progress Bar Panel
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.01),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Academy Progress',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3A59),
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}% Completed',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '$completionCount of ${_lessons.length} lessons completed',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),

            // Lessons List
            const Text(
              'Cognitive Lessons',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3A59),
              ),
            ),
            const SizedBox(height: 12.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _lessons.length,
              itemBuilder: (context, index) {
                final lesson = _lessons[index];
                final isCompleted = _completedLessons.contains(index);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: isCompleted ? theme.colorScheme.primary.withOpacity(0.3) : Colors.grey.shade200,
                        width: isCompleted ? 1.5 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.01),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: () => _showLessonBottomSheet(context, index),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lesson['title']!,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2E3A59),
                                      ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    Text(
                                      lesson['description']!,
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: const Color(0xFF2E3A59).withOpacity(0.65),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              if (isCompleted)
                                Icon(Icons.check_circle, color: theme.colorScheme.primary)
                              else
                                Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 16.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );

    if (widget.isEmbedded) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CBT Cognitive Lessons'),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: content,
    );
  }

  Widget _buildBadgeWidget({
    required String badge,
    required String label,
    required bool isActive,
    required ThemeData theme,
  }) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isActive ? 1.0 : 0.25,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: isActive ? theme.colorScheme.primary.withOpacity(0.12) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: isActive ? theme.colorScheme.primary : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: isActive ? theme.colorScheme.primary : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.0,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? const Color(0xFF2E3A59) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

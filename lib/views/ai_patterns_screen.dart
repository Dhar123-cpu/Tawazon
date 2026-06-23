import 'package:flutter/material.dart';

class AiPatternsScreen extends StatefulWidget {
  const AiPatternsScreen({super.key});

  @override
  State<AiPatternsScreen> createState() => _AiPatternsScreenState();
}

class _AiPatternsScreenState extends State<AiPatternsScreen> {
  final Set<int> _expandedIndices = {
    0
  }; // Default expand first pattern to highlight interactivity

  // Interactive exercises state
  final List<bool> _preMealChecks = [false, false, false];
  final List<bool> _sleepChecks = [false, false, false];
  int? _selectedWeekendActivity;

  final List<String> _weekendActivities = [
    'Reading a favorite book',
    'Taking a slow walk in a local park',
    'Listening to a calming music album',
    'Lying down screen-free for 30 minutes',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> patterns = [
      {
        'title': 'Pre-Meal Stress Spikes',
        'occurrence': 'Detected 3x this week',
        'icon': Icons.restaurant_rounded,
        'color': const Color(0xFF4DB6AC), // Soft Teal
        'description':
            'Your anxiety logs indicate a subtle increase in emotional intensity approximately 15 to 30 minutes prior to scheduled meal times.',
        'suggestion':
            'Consider taking a slow 3-minute centering breath sequence or pausing to note 3 peaceful sights and sounds in your immediate surroundings before transition times.'
      },
      {
        'title': 'Late Night Reflection Peak',
        'occurrence': 'Consistent habit pattern',
        'icon': Icons.nightlight_round,
        'color': const Color(0xFFB39DDB), // Soft Lavender
        'description':
            'Your most detailed, self-supportive journal entries occur after 9:00 PM, showing strong self-awareness during late hours.',
        'suggestion':
            'This is a wonderful reflection habit. Continue wrapping up your day with these logs. Try pairing them with a warm cup of herbal tea and dimming your screen to ease into sleep.'
      },
      {
        'title': 'Weekend Responsibility Pressure',
        'occurrence': 'Detected on Saturdays',
        'icon': Icons.calendar_month_rounded,
        'color': const Color(0xFFFFB74D), // Soft Orange
        'description':
            'Saturdays show a minor increase in logs containing self-imposed pressure or worries about productivity and schedules.',
        'suggestion':
            'Remember that intentional rest is an active part of wellness. Try scheduling one small activity purely for pleasure rather than productivity, and give yourself full permission to enjoy it.'
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindful Insights AI'),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header card
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE0F2F1), // Soft primary teal shade
                    Color(0xFFEDE7F6), // Soft lavender shade
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                    color: const Color(0xFF4DB6AC).withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.psychology_outlined,
                          color: theme.colorScheme.primary,
                          size: 28.0,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      const Text(
                        'AI Cognitive Insights',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2E3A59),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    'Our secure pattern detector maps recurring themes in your journal logs and mood check-ins to offer gentle, non-prescriptive suggestions.',
                    style: TextStyle(
                      fontSize: 13.0,
                      color: const Color(0xFF2E3A59).withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28.0),

            // Section Title
            const Text(
              'Detected Core Patterns',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3A59),
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Tap cards to expand interactive coping drills.',
              style: TextStyle(fontSize: 12.0, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12.0),

            // Patterns List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: patterns.length,
              itemBuilder: (context, index) {
                final pattern = patterns[index];
                final color = pattern['color'] as Color;
                final isExpanded = _expandedIndices.contains(index);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20.0),
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedIndices.remove(index);
                        } else {
                          _expandedIndices.add(index);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: isExpanded
                              ? color.withOpacity(0.5)
                              : Colors.grey.shade200,
                          width: isExpanded ? 1.5 : 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.01),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon + Title + Occurrence + Expand Arrow
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Icon(
                                  pattern['icon'] as IconData,
                                  color: color,
                                  size: 24.0,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pattern['title']!,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2E3A59),
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      pattern['occurrence']!,
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        color: color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                isExpanded
                                    ? Icons.expand_less_rounded
                                    : Icons.expand_more_rounded,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),

                          // Pattern Description
                          Text(
                            pattern['description']!,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: const Color(0xFF2E3A59).withOpacity(0.8),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // Soothing Suggestion box
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(color: Colors.grey.shade100),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.favorite_border_rounded,
                                      color: theme.colorScheme.primary,
                                      size: 16.0,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      'Soothing Suggestion',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  pattern['suggestion']!,
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: const Color(0xFF2E3A59)
                                        .withOpacity(0.7),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Expandable Coping Exercise
                          if (isExpanded) ...[
                            const Divider(height: 32.0, thickness: 1.0),
                            _buildCopingExercise(index, theme),
                          ],
                        ],
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
  }

  Widget _buildCopingExercise(int index, ThemeData theme) {
    if (index == 0) {
      // 5-4-3-2-1 countdown drill for Pre-Meal Stress
      final allChecked = _preMealChecks.every((val) => val);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Interactive Tool: 5-4-3-2-1 Sensory Countdown',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
                color: Color(0xFF2E3A59)),
          ),
          const SizedBox(height: 4.0),
          const Text(
            'Ground yourself in this moment by ticking off the items as you find them:',
            style: TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
          const SizedBox(height: 12.0),
          _buildCheckItem(
              0, 'Name 3 peaceful sights in your room', _preMealChecks, 0),
          _buildCheckItem(
              1, 'Notice 2 soft sounds around you', _preMealChecks, 0),
          _buildCheckItem(
              2, 'Touch 1 safe texture near your seat', _preMealChecks, 0),
          if (allChecked) ...[
            const SizedBox(height: 12.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Row(
                children: [
                  Text('🌱', style: TextStyle(fontSize: 18.0)),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Excellent! You are grounded. Enjoy your meal with presence and self-love.',
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00796B)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    } else if (index == 1) {
      // Sleep Prep Drill
      final allChecked = _sleepChecks.every((val) => val);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Interactive Tool: Quiet Evening Transition Checklist',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
                color: Color(0xFF2E3A59)),
          ),
          const SizedBox(height: 4.0),
          const Text(
            'Gently step into sleep mode by completing these soothing tasks:',
            style: TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
          const SizedBox(height: 12.0),
          _buildCheckItem(
              0, 'Poured a warm decaf beverage/tea', _sleepChecks, 1),
          _buildCheckItem(
              1, 'Dimmed screens / enabled night light mode', _sleepChecks, 1),
          _buildCheckItem(
              2, 'Left anxieties safely inside the journal', _sleepChecks, 1),
          if (allChecked) ...[
            const SizedBox(height: 12.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE7F6),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Row(
                children: [
                  Text('🌙', style: TextStyle(fontSize: 18.0)),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Ready for rest. Sleep peacefully, knowing you did your best today.',
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF512DA8)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    } else {
      // Weekend priority selector
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Interactive Tool: Weekend Pleasure Committer',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
                color: Color(0xFF2E3A59)),
          ),
          const SizedBox(height: 4.0),
          const Text(
            'Commit to one small pleasure activity this Saturday to override routine pressure:',
            style: TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
          const SizedBox(height: 12.0),
          for (int i = 0; i < _weekendActivities.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedWeekendActivity = i;
                  });
                },
                borderRadius: BorderRadius.circular(8.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 4.0),
                  child: Row(
                    children: [
                      Icon(
                        _selectedWeekendActivity == i
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_off_rounded,
                        color: _selectedWeekendActivity == i
                            ? theme.colorScheme.primary
                            : Colors.grey,
                        size: 20.0,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          _weekendActivities[i],
                          style: const TextStyle(
                              fontSize: 13.0, color: Color(0xFF2E3A59)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_selectedWeekendActivity != null) ...[
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  const Text('🌸', style: TextStyle(fontSize: 18.0)),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Commitment locked! Enjoy ${_weekendActivities[_selectedWeekendActivity!].toLowerCase()} with full permission to rest.',
                      style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE65100)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    }
  }

  Widget _buildCheckItem(
      int stepIndex, String text, List<bool> checkList, int listId) {
    final isChecked = checkList[stepIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () {
          setState(() {
            checkList[stepIndex] = !isChecked;
          });
        },
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
          child: Row(
            children: [
              Icon(
                isChecked
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank_rounded,
                color: isChecked ? const Color(0xFF4DB6AC) : Colors.grey,
                size: 20.0,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 13.0,
                    decoration: isChecked ? TextDecoration.lineThrough : null,
                    color: isChecked ? Colors.grey : const Color(0xFF2E3A59),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

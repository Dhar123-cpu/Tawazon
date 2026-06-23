import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Hardcoded statistics for emotional and self-care tracking
    final List<Map<String, dynamic>> stats = [
      {'label': 'CBT Lessons Completed', 'value': '4 / 4', 'icon': Icons.menu_book_rounded, 'color': const Color(0xFFB39DDB)},
      {'label': 'Mindful Breathing Sessions', 'value': '18 sessions', 'icon': Icons.air_rounded, 'color': const Color(0xFF4DB6AC)},
      {'label': 'Encrypted Journal Entries', 'value': '8 written', 'icon': Icons.lock_outline, 'color': const Color(0xFF90A4AE)},
      {'label': 'Emotional Self-Checks', 'value': '12 logged', 'icon': Icons.analytics_outlined, 'color': const Color(0xFFFFB74D)},
    ];

    // Weekly Mood Logs: 1-5 scale (1: Sad, 2: Anxious, 3: Neutral, 4: Calm, 5: Happy)
    final List<Map<String, dynamic>> weeklyMoods = [
      {'day': 'Mon', 'score': 3, 'label': '😐'},
      {'day': 'Tue', 'score': 4, 'label': '😌'},
      {'day': 'Wed', 'score': 2, 'label': '😟'},
      {'day': 'Thu', 'score': 4, 'label': '😌'},
      {'day': 'Fri', 'score': 5, 'label': '😊'},
      {'day': 'Sat', 'score': 3, 'label': '😐'},
      {'day': 'Sun', 'score': 5, 'label': '😊'},
    ];

    final List<Map<String, dynamic>> milestones = [
      {
        'title': 'Mindfulness Spark',
        'subtitle': 'Completed 5 breathing cycles',
        'isCompleted': true,
        'badge': '🏅'
      },
      {
        'title': 'CBT Explorer',
        'subtitle': 'Completed your first cognitive reframing lesson',
        'isCompleted': true,
        'badge': '🏅'
      },
      {
        'title': 'Emotional Consistency',
        'subtitle': 'Logged mood for 7 consecutive days',
        'isCompleted': true,
        'badge': '🏅'
      },
      {
        'title': 'Reflection Practice',
        'subtitle': 'Write 15 secure journal reflections',
        'isCompleted': false,
        'progress': '8 / 15 completed',
        'badge': '⏳'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recovery Progress Summary'),
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
            // Header
            Text(
              'Your Growth Journey',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2E3A59),
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              'Reviewing your cognitive milestones and emotional balance. Growth is non-linear—every small step is a victory.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF2E3A59).withOpacity(0.6),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24.0),

            // Mood Trends Section (Custom Bar Chart)
            const Text(
              'Weekly Mood Trends',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3A59),
              ),
            ),
            const SizedBox(height: 12.0),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.01),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mood Balance Index',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E3A59).withOpacity(0.7),
                        ),
                      ),
                      Text(
                        'Stable & Grounded',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  // Bar Graph Visualizer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: weeklyMoods.map((mood) {
                      final double scorePercentage = mood['score'] / 5.0;
                      final double barHeight = scorePercentage * 120.0;

                      return Column(
                        children: [
                          Text(
                            mood['label']!,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 6.0),
                          Container(
                            width: 24.0,
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.2 + (scorePercentage * 0.6)),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            mood['day']!,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2E3A59).withOpacity(0.6),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28.0),

            // Statistics Grid Section
            const Text(
              'Activity Statistics',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3A59),
              ),
            ),
            const SizedBox(height: 12.0),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.4,
              ),
              itemCount: stats.length,
              itemBuilder: (context, index) {
                final stat = stats[index];
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: Colors.grey.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.01),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: (stat['color'] as Color).withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          stat['icon'] as IconData,
                          color: stat['color'] as Color,
                          size: 20.0,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stat['value']!,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E3A59),
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            stat['label']!,
                            style: TextStyle(
                              fontSize: 11.0,
                              color: const Color(0xFF2E3A59).withOpacity(0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 28.0),

            // Milestones Section
            const Text(
              'Recovery Milestones',
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
              itemCount: milestones.length,
              itemBuilder: (context, index) {
                final milestone = milestones[index];
                final isCompleted = milestone['isCompleted'] as bool;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: isCompleted ? const Color(0xFFE8F5E9) : Colors.white, // Light green for completed
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: isCompleted ? Colors.green.shade100 : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: isCompleted ? Colors.green.shade200.withOpacity(0.4) : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            milestone['badge']!,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                milestone['title']!,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                milestone['subtitle']!,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: const Color(0xFF2E3A59).withOpacity(0.6),
                                ),
                              ),
                              if (!isCompleted && milestone.containsKey('progress')) ...[
                                const SizedBox(height: 6.0),
                                Text(
                                  milestone['progress']!,
                                  style: TextStyle(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (isCompleted) ...[
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            color: Color(0xFF2E7D32),
                          ),
                        ],
                      ],
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
}

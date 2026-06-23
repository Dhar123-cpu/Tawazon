import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tawazon/views/progress_screen.dart';
import 'package:tawazon/views/ai_patterns_screen.dart';
import 'package:tawazon/views/professional_help_screen.dart';

class HomeDashboard extends StatefulWidget {
  final bool isEmbedded;
  final Function(int)? onTabRequested;
  const HomeDashboard(
      {super.key, this.isEmbedded = false, this.onTabRequested});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _currentIndex = 0;
  int? _selectedMoodIndex;
  bool _isSyncingMood = false;
  int? _lastSyncedMoodIndex;

  // Guided Onboarding Tour State
  bool _isTourActive = false;
  int _tourStep = 0;

  final List<Map<String, String>> _moods = [
    {'emoji': '😊', 'label': 'Happy'},
    {'emoji': '😌', 'label': 'Calm'},
    {'emoji': '😐', 'label': 'Neutral'},
    {'emoji': '😟', 'label': 'Anxious'},
    {'emoji': '😔', 'label': 'Sad'},
  ];

  Future<void> _syncMoodToFirebase(String moodLabel, String emoji) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError("Cannot sync mood when user is not signed in.");
    }
    await FirebaseFirestore.instance
        .collection('artifacts')
        .doc('tawazon-95f97')
        .collection('users')
        .doc(user.uid)
        .collection('moods')
        .add({
      'mood': moodLabel,
      'emoji': emoji,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Tawazon';
      case 1:
        return 'AI Cognitive Insights';
      case 2:
        return 'Your Growth Journey';
      case 3:
        return 'Support & Resources';
      default:
        return 'Tawazon';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget homeBody = Stack(
      children: [
        _buildHomeBody(theme),
        if (_isTourActive) _buildTourOverlay(theme),
      ],
    );

    if (widget.isEmbedded) {
      return homeBody;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign Out',
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          homeBody,
          const AiPatternsScreen(),
          const ProgressScreen(),
          const ProfessionalHelpScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology_outlined),
            activeIcon: Icon(Icons.psychology_rounded),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_rounded),
            activeIcon: Icon(Icons.trending_up_rounded),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline_rounded),
            activeIcon: Icon(Icons.favorite_rounded),
            label: 'Support',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeBody(ThemeData theme) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── GRADIENT HERO CARD ──────────────────────────────────────────
            GestureDetector(
              onTap: () => _showStreakDialog(context, theme),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4DB6AC), Color(0xFF9C7FD4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4DB6AC).withOpacity(0.35),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Decorative background blobs
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: -30,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.04),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Good Morning, Friend 👋',
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Take a deep breath and start your day mindfully.',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.help_outline_rounded,
                                  color: Colors.white70, size: 22),
                              tooltip: 'Guided App Tour',
                              onPressed: () {
                                setState(() {
                                  _isTourActive = true;
                                  _tourStep = 0;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Streak row
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Text('🌱',
                                  style: TextStyle(fontSize: 22)),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '12 Days of Self-Care',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'STREAK TRACKER • TAP TO VIEW',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.75),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const Icon(Icons.arrow_forward_ios_rounded,
                                  color: Colors.white70, size: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Weekly Check-in Banner
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/risk_assessment');
                },
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F1), // Very soft primary teal
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: const Color(0xFF4DB6AC).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4DB6AC).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Color(0xFF00796B),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Weekly Check-in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Color(0xFF2E3A59),
                              ),
                            ),
                            SizedBox(height: 2.0),
                            Text(
                              'Take your emotional self-assessment.',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xFF2E3A59),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF00796B),
                        size: 16.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32.0),

            // Mood Selector Section
            Row(
              children: [
                const Text(
                  'Daily Mood',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3A59),
                  ),
                ),
                const Spacer(),
                if (_lastSyncedMoodIndex == _selectedMoodIndex &&
                    _selectedMoodIndex != null)
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_done_rounded,
                          color: Color(0xFF4DB6AC), size: 16.0),
                      SizedBox(width: 4.0),
                      Text(
                        'Cloud Synced',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF4DB6AC),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                else if (_isSyncingMood)
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 12.0,
                        height: 12.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFB39DDB)),
                        ),
                      ),
                      SizedBox(width: 6.0),
                      Text(
                        'Syncing...',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFFB39DDB),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(_moods.length, (index) {
                  final mood = _moods[index];
                  final isSelected = _selectedMoodIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          _selectedMoodIndex = index;
                          _isSyncingMood = true;
                        });
                        try {
                          await _syncMoodToFirebase(mood['label']!, mood['emoji']!);
                          setState(() {
                            _isSyncingMood = false;
                            _lastSyncedMoodIndex = index;
                          });
                        } catch (e) {
                          setState(() {
                            _isSyncingMood = false;
                          });
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSelected ? 18.0 : 16.0,
                          vertical: isSelected ? 14.0 : 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withOpacity(0.10)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : const Color(0xFFEEF1F5),
                            width: isSelected ? 2.0 : 1.0,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.22),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  )
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                  fontSize: isSelected ? 32.0 : 28.0),
                              child: Text(mood['emoji']!),
                            ),
                            const SizedBox(height: 6.0),
                            Text(
                              mood['label']!,
                              style: TextStyle(
                                fontSize: 11.0,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : const Color(0xFF6B7A99),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Interactive Mood Reflection Card
            _buildMoodReflectionCard(theme),
            const SizedBox(height: 32.0),

            // Quick Actions Grid Section
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3A59),
              ),
            ),
            const SizedBox(height: 12.0),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.3,
              children: [
                _buildActionCard(
                  title: 'Journal',
                  subtitle: 'Write your thoughts',
                  icon: Icons.edit_note_rounded,
                  backgroundColor: const Color(0xFFE0F2F1), // Soft Mint
                  iconColor: const Color(0xFF00796B),
                  context: context,
                ),
                _buildActionCard(
                  title: 'CBT Lesson',
                  subtitle: 'Cognitive balance',
                  icon: Icons.menu_book_rounded,
                  backgroundColor: const Color(0xFFEDE7F6), // Soft Lavender
                  iconColor: const Color(0xFF512DA8),
                  context: context,
                ),
                _buildActionCard(
                  title: 'Breathing',
                  subtitle: 'Calm your mind',
                  icon: Icons.self_improvement_rounded,
                  backgroundColor: const Color(0xFFE1F5FE), // Soft Sky Blue
                  iconColor: const Color(0xFF0288D1),
                  context: context,
                ),
                _buildActionCard(
                  title: 'Reminder',
                  subtitle: 'Stay on track',
                  icon: Icons.notifications_active_outlined,
                  backgroundColor: const Color(0xFFFFF3E0), // Soft Peach
                  iconColor: const Color(0xFFF57C00),
                  context: context,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        if (title == 'Journal') {
          if (widget.isEmbedded && widget.onTabRequested != null) {
            widget.onTabRequested!(1);
          } else {
            Navigator.pushNamed(context, '/journal');
          }
        } else if (title == 'CBT Lesson') {
          if (widget.isEmbedded && widget.onTabRequested != null) {
            widget.onTabRequested!(2);
          } else {
            Navigator.pushNamed(context, '/cbt_learning');
          }
        } else if (title == 'Breathing') {
          if (widget.isEmbedded && widget.onTabRequested != null) {
            widget.onTabRequested!(3);
          } else {
            Navigator.pushNamed(context, '/coping_tools');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening $title...'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(milliseconds: 500),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon container with tinted background
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24.0),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.0,
                    color: Color(0xFF1E2D47),
                  ),
                ),
                  const SizedBox(height: 2.0),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: const Color(0xFF2E3A59).withOpacity(0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildMoodReflectionCard(ThemeData theme) {
    if (_selectedMoodIndex == null) return const SizedBox.shrink();

    final mood = _moods[_selectedMoodIndex!];
    final label = mood['label']!;
    String message = '';
    String buttonText = '';
    int tabIndex = 0;
    bool isRoute = false;
    String routeName = '';

    switch (label) {
      case 'Happy':
      case 'Calm':
        message =
            'That is wonderful to hear! Consider recording a positive affirmation in your Journal or continuing a CBT lesson to reinforce your peaceful mindset.';
        buttonText = 'Explore CBT Academy';
        tabIndex = 2;
        break;
      case 'Neutral':
        message =
            'A balanced baseline is a great space to build from. Take a look at your AI Mindful Insights to see what helps keep you centered.';
        buttonText = 'View AI Insights';
        isRoute = true;
        routeName = '/ai_patterns';
        break;
      case 'Anxious':
      case 'Sad':
        message =
            'It is completely okay and natural to feel this way. Let\'s practice a 3-minute centering breath sequence together to ground ourselves.';
        buttonText = 'Start Breathing';
        tabIndex = 3;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1), // Soft primary mint teal
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFF4DB6AC).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                '${mood['emoji']} Reflections',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Color(0xFF2E3A59),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 18.0),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _selectedMoodIndex = null;
                  });
                },
              )
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            message,
            style: const TextStyle(
              fontSize: 13.0,
              color: Color(0xFF2E3A59),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12.0),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                if (isRoute) {
                  Navigator.pushNamed(context, routeName);
                } else if (widget.onTabRequested != null) {
                  widget.onTabRequested!(tabIndex);
                } else {
                  setState(() {
                    _currentIndex = tabIndex;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                textStyle: const TextStyle(
                    fontSize: 12.0, fontWeight: FontWeight.bold),
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }

  void _showStreakDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          title: const Text(
            '🌱 Streak Milestones',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3A59),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Every day you check in, practice breathing, or write a journal entry adds to your streak container.',
                style: TextStyle(fontSize: 13.0, color: Color(0xFF2E3A59)),
              ),
              const SizedBox(height: 16.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Level: Sapling 🌲',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                        color: Color(0xFF2E3A59)),
                  ),
                  Text(
                    '12 / 15 Days',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                        color: Color(0xFF2E3A59)),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: LinearProgressIndicator(
                  value: 12 / 15,
                  minHeight: 10,
                  backgroundColor: Colors.grey.shade100,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                ),
              ),
              const SizedBox(height: 20.0),
              _buildMilestoneRow('Seed 🌱', '1-3 Days of Care', true),
              const SizedBox(height: 10.0),
              _buildMilestoneRow('Sprout 🌿', '4-7 Days of Care', true),
              const SizedBox(height: 10.0),
              _buildMilestoneRow('Sapling 🌲', '8-14 Days of Care', true),
              const SizedBox(height: 10.0),
              _buildMilestoneRow('Resilient Oak 🌳', '15+ Days of Care', false),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMilestoneRow(String badge, String description, bool completed) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            color: completed ? const Color(0xFFE0F2F1) : Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            completed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: completed ? const Color(0xFF4DB6AC) : Colors.grey,
            size: 16.0,
          ),
        ),
        const SizedBox(width: 12.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              badge,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
                color: completed ? const Color(0xFF2E3A59) : Colors.grey,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 11.0,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTourOverlay(ThemeData theme) {
    String stepText = '';
    String stepTitle = '';
    Widget highlightedPlaceholder = const SizedBox.shrink();

    switch (_tourStep) {
      case 0:
        stepTitle = 'Streak Tracker';
        stepText =
            'Consistency is key to recovery. The Streak Tracker celebrates every consecutive day you engage in self-care. Tap the card anytime to view your milestones!';
        highlightedPlaceholder = Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFB39DDB),
                Color(0xFFD1C4E9),
              ],
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('STREAK TRACKER',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Text('12 Days of Self-Care 🌱',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        );
        break;
      case 1:
        stepTitle = 'Daily Mood Tracker';
        stepText =
            'Log how you feel throughout the day. Tap an emoji to check in, and Tawazon will provide instant supportive reflections and customize your AI Insights.';
        highlightedPlaceholder = Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: theme.colorScheme.primary, width: 2),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('😊', style: TextStyle(fontSize: 24.0)),
              Text('😌', style: TextStyle(fontSize: 24.0)),
              Text('😐', style: TextStyle(fontSize: 24.0)),
              Text('😟', style: TextStyle(fontSize: 24.0)),
              Text('😔', style: TextStyle(fontSize: 24.0)),
            ],
          ),
        );
        break;
      case 2:
        stepTitle = 'Quick Actions';
        stepText =
            'Instant access to core wellness tools. Easily navigate to write in your private Journal, complete a CBT lesson, or use the Breathing Calmer timer.';
        highlightedPlaceholder = Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.circular(16.0)),
                child: const Text('Journal',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF2E3A59))),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    color: const Color(0xFFEDE7F6),
                    borderRadius: BorderRadius.circular(16.0)),
                child: const Text('Breathing',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF2E3A59))),
              ),
            ),
          ],
        );
        break;
      case 3:
        stepTitle = 'Mindful Drawer & More';
        stepText =
            'Slide open the side drawer (tap hamburger menu in top left) to access advanced analytics: Risk Quiz, AI Insight logs, and local crisis helplines.';
        highlightedPlaceholder = Row(
          children: [
            Icon(Icons.menu_rounded,
                color: theme.colorScheme.primary, size: 32.0),
            const SizedBox(width: 12.0),
            const Text('Swipe from left or tap menu icon',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        );
        break;
    }

    return Positioned.fill(
      child: Material(
        color: Colors.black.withOpacity(0.75),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'App Feature Guide (${_tourStep + 1}/4)',
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isTourActive = false;
                          });
                        },
                        child: const Text('Skip Tour',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),

                  // Spotlight Container
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: highlightedPlaceholder,
                  ),
                  const SizedBox(height: 16.0),

                  // Explanatory dialogue bubble
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          stepTitle,
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          stepText,
                          style: TextStyle(
                            fontSize: 13.0,
                            color: const Color(0xFF2E3A59).withOpacity(0.8),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (_tourStep > 0)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _tourStep--;
                                  });
                                },
                                child: const Text('Back'),
                              ),
                            const SizedBox(width: 8.0),
                            ElevatedButton(
                              onPressed: () {
                                if (_tourStep < 3) {
                                  setState(() {
                                    _tourStep++;
                                  });
                                } else {
                                  setState(() {
                                    _isTourActive = false;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(_tourStep == 3 ? 'Finish' : 'Next'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tawazon/views/home_dashboard.dart';
import 'package:tawazon/views/journal_screen.dart';
import 'package:tawazon/views/cbt_learning_screen.dart';
import 'package:tawazon/views/coping_tools_screen.dart';
import 'package:tawazon/views/settings_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<String> _titles = [
    'Tawazon',
    'Safe Journal',
    'CBT Academy',
    'Breathing Calmer',
    'Settings',
  ];

  final List<({IconData icon, IconData activeIcon, String label})> _navItems = [
    (icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.edit_note_rounded, activeIcon: Icons.edit_note_rounded, label: 'Journal'),
    (icon: Icons.menu_book_rounded, activeIcon: Icons.menu_book_rounded, label: 'CBT'),
    (icon: Icons.self_improvement_rounded, activeIcon: Icons.self_improvement_rounded, label: 'Breathe'),
    (icon: Icons.settings_outlined, activeIcon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    const navBg = Colors.white;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: const Color(0xFFF7F9FA),
        // Flutter auto-adds drawer hamburger icon
      ),
      drawer: _buildDrawer(context, theme),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeDashboard(
            isEmbedded: true,
            onTabRequested: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          const JournalScreen(isEmbedded: true),
          const CbtLearningScreen(isEmbedded: true),
          const CopingToolsScreen(isEmbedded: true),
          const SettingsScreen(isEmbedded: true),
        ],
      ),
      // Premium floating pill bottom nav
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBg,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: navBg,
            surfaceTintColor: Colors.transparent,
            indicatorColor: primary.withOpacity(0.12),
            height: 68,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: _navItems.map((item) {
              return NavigationDestination(
                icon: Icon(item.icon, size: 24),
                selectedIcon: Icon(item.activeIcon, size: 24, color: primary),
                label: item.label,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, ThemeData theme) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Gradient Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4DB6AC), Color(0xFF9C7FD4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tawazon',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Recovery & Harmony',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                _buildDrawerItem(
                  icon: Icons.health_and_safety_outlined,
                  label: 'Tawazon Risk Assessment Quiz',
                  iconColor: const Color(0xFF4DB6AC),
                  bgColor: const Color(0xFFE0F7F4),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/risk_assessment');
                  },
                ),
                const SizedBox(height: 8),
                _buildDrawerItem(
                  icon: Icons.psychology_outlined,
                  label: 'Mindful Insights AI',
                  iconColor: const Color(0xFF9C7FD4),
                  bgColor: const Color(0xFFF0EBFF),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/ai_patterns');
                  },
                ),
                const SizedBox(height: 8),
                _buildDrawerItem(
                  icon: Icons.favorite_outline_rounded,
                  label: 'Support Circles & Helplines',
                  iconColor: const Color(0xFFE57373),
                  bgColor: const Color(0xFFFFF0F0),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/professional_help');
                  },
                ),
                const SizedBox(height: 8),
                _buildDrawerItem(
                  icon: Icons.trending_up_rounded,
                  label: 'Recovery Progress Summary',
                  iconColor: const Color(0xFF42A5F5),
                  bgColor: const Color(0xFFE8F4FF),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/progress');
                  },
                ),
              ],
            ),
          ),

          // Divider + Sign Out
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: _buildDrawerItem(
              icon: Icons.logout_rounded,
              label: 'Sign Out',
              iconColor: const Color(0xFF6B7A99),
              bgColor: const Color(0xFFF5F5F8),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E2D47),
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

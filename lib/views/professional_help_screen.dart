import 'package:flutter/material.dart';

class ProfessionalHelpScreen extends StatefulWidget {
  const ProfessionalHelpScreen({super.key});

  @override
  State<ProfessionalHelpScreen> createState() => _ProfessionalHelpScreenState();
}

class _ProfessionalHelpScreenState extends State<ProfessionalHelpScreen> {
  int _selectedTab = 0; // 0: Crisis Lines, 1: Outpatient Centers, 2: Family Workbook

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Circles & Helplines'),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Section Padding
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Support & Resources',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    'Connect with professional assistance in the UAE and access guidance resources.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF2E3A59).withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Sliding Segment Switcher Tab
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  children: [
                    _buildTabButton(0, 'Crisis Lines', theme),
                    _buildTabButton(1, 'Centers', theme),
                    _buildTabButton(2, 'Workbook', theme),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Main Content Area
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _buildActiveContent(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String title, ThemeData theme) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13.0,
              color: isSelected ? theme.colorScheme.primary : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveContent(ThemeData theme) {
    switch (_selectedTab) {
      case 0:
        return _buildCrisisLinesTab(theme);
      case 1:
        return _buildCentersTab(theme);
      case 2:
        return _buildWorkbookTab(theme);
      default:
        return _buildCrisisLinesTab(theme);
    }
  }

  Widget _buildCrisisLinesTab(ThemeData theme) {
    final List<Map<String, String>> hotlines = [
      {
        'name': 'Hope Line',
        'number': '8004673',
        'provider': 'UAE Federal Mental Health Support',
        'description': 'Free and confidential supportive mental health counseling helpline available daily.'
      },
      {
        'name': 'Estijaba Helpline',
        'number': '8001717',
        'provider': 'Department of Health (Abu Dhabi)',
        'description': 'Crisis helpline providing supportive psychological guidance and medical referrals.'
      },
      {
        'name': 'National Rehabilitation Center',
        'number': '80022',
        'provider': 'NRC UAE',
        'description': 'Dedicated wellness helpline for recovery support, counseling, and guidance.'
      }
    ];

    return ListView.builder(
      key: const ValueKey<int>(0),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemCount: hotlines.length,
      itemBuilder: (context, index) {
        final hotline = hotlines[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      hotline['name']!,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone_in_talk_rounded, color: Color(0xFF4DB6AC)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Simulating call to ${hotline['name']} (${hotline['number']})...'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Text(
                  hotline['provider']!,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  hotline['description']!,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: const Color(0xFF2E3A59).withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCentersTab(ThemeData theme) {
    final List<Map<String, String>> clinics = [
      {
        'name': 'Al Amal Psychiatric Hospital',
        'location': 'Dubai, UAE',
        'specialty': 'Outpatient Psychiatric & Counseling',
        'details': 'Offers complete psychiatric assessments, family therapy, and mental health outpatient clinics in Dubai.'
      },
      {
        'name': 'Maudsley Health',
        'location': 'Abu Dhabi & Dubai, UAE',
        'specialty': 'Child, Adolescent & Adult Outpatient care',
        'details': 'Brings specialized therapeutic guidelines from the UK, emphasizing outpatient CBT and family recovery support.'
      },
      {
        'name': 'American Center for Psychiatry and Neurology (ACPN)',
        'location': 'Abu Dhabi, Dubai, Al Ain, UAE',
        'specialty': 'Multidisciplinary Mental Wellness',
        'details': 'Provides psychotherapy, counseling, psychiatric clinics, and behavioral therapy in various clinics in the UAE.'
      },
      {
        'name': 'Camali Clinic',
        'location': 'Dubai Healthcare City, UAE',
        'specialty': 'Child & Adolescent Mental Health',
        'details': 'Dedicated outpatient center focusing on therapeutic connection and emotional balance counseling for youth and families.'
      }
    ];

    return ListView.builder(
      key: const ValueKey<int>(1),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemCount: clinics.length,
      itemBuilder: (context, index) {
        final clinic = clinics[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clinic['name']!,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3A59),
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14.0, color: Colors.grey),
                    const SizedBox(width: 4.0),
                    Text(
                      clinic['location']!,
                      style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Text(
                  clinic['specialty']!,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  clinic['details']!,
                  style: TextStyle(
                    fontSize: 13.0,
                    color: const Color(0xFF2E3A59).withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWorkbookTab(ThemeData theme) {
    final List<Map<String, String>> guidance = [
      {
        'title': 'Guide for Parents',
        'subtitle': 'Supporting without focus on physical traits',
        'content': '• Understand recovery as a non-linear process: Backsteps can occur. Validate emotional struggles rather than focusing on physical milestones.\n• Create a low-pressure household environment: Do not discuss portion sizes, calorie values, or weight trends at the family table.\n• Emphasize connection: Focus conversations around hobbies, feelings, and routine stability to support identity outside the recovery path.'
      },
      {
        'title': 'Guide for Siblings',
        'subtitle': 'Providing safe connection and companionship',
        'content': '• You do not need to act as their counselor: Simply being a sibling who offers regular, non-recovery-focused connection is highly therapeutic.\n• Engage in low-pressure shared activities: Plan routine walks, watch films, or do arts together without drawing attention to physical changes or recovery timelines.\n• Be an active listener: If they choose to share their feelings, validate their space and encourage them without giving medical warnings.'
      },
      {
        'title': 'Guide for Guardians',
        'subtitle': 'Autonomy-respecting wellness coordination',
        'content': '• Respect their personal agency: Encourage them to coordinate self-care steps (like CBT lessons or breathing apps) themselves, avoiding hovering routines.\n• Coordinate with specialists: Assist with administrative visits to outpatient clinics (ACPN, Maudsley, Al Amal) quietly, keeping health talks low-key.\n• Establish a reliable safety net: Offer calm validation when they seek your help, letting them know that you support them regardless of speed.'
      }
    ];

    return ListView.builder(
      key: const ValueKey<int>(2),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemCount: guidance.length,
      itemBuilder: (context, index) {
        final guide = guidance[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Theme(
                data: theme.copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                childrenPadding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                title: Text(
                  guide['title']!,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3A59),
                  ),
                ),
                subtitle: Text(
                  guide['subtitle']!,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  Text(
                    guide['content']!,
                    style: TextStyle(
                      fontSize: 13.0,
                      color: const Color(0xFF2E3A59).withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      },
    );
  }
}

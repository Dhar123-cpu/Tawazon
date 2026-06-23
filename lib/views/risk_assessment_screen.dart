import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RiskAssessmentScreen extends StatefulWidget {
  const RiskAssessmentScreen({super.key});

  @override
  State<RiskAssessmentScreen> createState() => _RiskAssessmentScreenState();
}

class _RiskAssessmentScreenState extends State<RiskAssessmentScreen> {
  int _currentStep = 0; // 0 to 3 for questions, 4 for results
  int _totalScore = 0;
  int? _selectedOptionIndex;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'How would you rate your general stress levels today?',
      'options': [
        {'text': 'Very calm and low stress', 'score': 1},
        {'text': 'Mild, manageable stress', 'score': 2},
        {'text': 'High, moderately uncomfortable stress', 'score': 3},
        {'text': 'Overwhelming or severe stress', 'score': 4},
      ]
    },
    {
      'question': 'Have you felt overwhelmed by your emotions recently?',
      'options': [
        {'text': 'Not at all, I feel emotionally balanced', 'score': 1},
        {'text': 'Occasionally or mildly overwhelmed', 'score': 2},
        {'text': 'Frequently overwhelmed by emotions', 'score': 3},
        {'text': 'Almost constantly overwhelmed or numb', 'score': 4},
      ]
    },
    {
      'question': 'Are you feeling connected to your support network?',
      'options': [
        {'text': 'Very connected to friends and family', 'score': 1},
        {'text': 'Somewhat connected, but could be better', 'score': 2},
        {'text': 'A bit isolated or unsupported', 'score': 3},
        {'text': 'Completely isolated with no support', 'score': 4},
      ]
    },
    {
      'question': 'How stable do you feel in your daily routine?',
      'options': [
        {'text': 'Highly stable, healthy sleep and meals', 'score': 1},
        {'text': 'Mostly stable with minor disruptions', 'score': 2},
        {'text': 'Unstable, irregular routine or sleep', 'score': 3},
        {'text': 'Completely disrupted, struggling with routine', 'score': 4},
      ]
    }
  ];

  void _handleOptionSelect(int index) {
    setState(() {
      _selectedOptionIndex = index;
    });
  }

  void _syncQuizResultToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint("RiskAssessmentScreen: Cannot sync quiz result because user is null");
      return;
    }

    final String riskLevel;
    if (_totalScore <= 7) {
      riskLevel = 'Low Risk';
    } else if (_totalScore <= 12) {
      riskLevel = 'Moderate Risk';
    } else {
      riskLevel = 'High Risk';
    }

    try {
      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc('tawazon-95f97')
          .collection('users')
          .doc(user.uid)
          .collection('quiz_results')
          .add({
        'score': _totalScore,
        'riskLevel': riskLevel,
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint("RiskAssessmentScreen: Quiz results successfully synced to Firebase.");
    } catch (e) {
      debugPrint("RiskAssessmentScreen: Error syncing quiz results: $e");
    }
  }

  void _handleContinue() {
    if (_selectedOptionIndex == null) return;

    final selectedScore = _questions[_currentStep]['options']
        [_selectedOptionIndex!]['score'] as int;
    _totalScore += selectedScore;

    if (_currentStep == _questions.length - 1) {
      _syncQuizResultToFirebase();
    }

    setState(() {
      _currentStep++;
      _selectedOptionIndex = null; // Reset for next step
    });
  }

  void _resetQuiz() {
    setState(() {
      _currentStep = 0;
      _totalScore = 0;
      _selectedOptionIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isResultPage = _currentStep >= _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotional Check-in'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child:
              isResultPage ? _buildResultsPage(theme) : _buildQuizPage(theme),
        ),
      ),
    );
  }

  Widget _buildQuizPage(ThemeData theme) {
    final questionData = _questions[_currentStep];
    final progress = (_currentStep + 1) / _questions.length;

    return Padding(
      key: ValueKey<int>(_currentStep),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress Bar and step text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${_currentStep + 1} of ${_questions.length}',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}% Done',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: theme.colorScheme.onSurface.withOpacity(0.05),
              valueColor:
                  AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              minHeight: 8.0,
            ),
          ),
          const SizedBox(height: 36.0),

          // Question Title
          Text(
            questionData['question'],
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3A59),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24.0),

          // Options List
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: questionData['options'].length,
              itemBuilder: (context, index) {
                final option = questionData['options'][index];
                final isSelected = _selectedOptionIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _handleOptionSelect(index),
                      borderRadius: BorderRadius.circular(16.0),
                      child: Ink(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 18.0),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withOpacity(0.08)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : Colors.grey.shade200,
                            width: isSelected ? 2.0 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                option['text'],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: const Color(0xFF2E3A59),
                                ),
                              ),
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : Colors.grey.shade300,
                                  width: 2.0,
                                ),
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : Colors.transparent,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Continue Button
          ElevatedButton(
            onPressed: _selectedOptionIndex != null ? _handleContinue : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsPage(ThemeData theme) {
    // Risk assessment thresholds: low (4-7), moderate (8-12), high (13-16)
    final String riskLevel;
    final Color cardBackground;
    final Color textColor;
    final String description;
    final bool showProfessionalSupport;

    if (_totalScore <= 7) {
      riskLevel = 'Low Risk';
      cardBackground = const Color(0xFFE8F5E9); // Pastel Green
      textColor = const Color(0xFF2E7D32);
      description =
          'You are experiencing a low level of emotional risk. Continue practicing daily routines and self-care tasks to preserve your balanced lifestyle.';
      showProfessionalSupport = false;
    } else if (_totalScore <= 12) {
      riskLevel = 'Moderate Risk';
      cardBackground = const Color(0xFFFFFDE7); // Pastel Yellow
      textColor = const Color(0xFFF9A825);
      description =
          'You are experiencing moderate emotional risk. This is a common indicator that you could benefit from taking a step back, practicing breathing exercises, and connecting with others.';
      showProfessionalSupport = false;
    } else {
      riskLevel = 'High Risk';
      cardBackground = const Color(0xFFFFEBEE); // Pastel Red
      textColor = const Color(0xFFC62828);
      description =
          'Your current emotional risk is high. Please remember that seeking support is a sign of strength. We strongly encourage talking with someone who can help you navigate this space.';
      showProfessionalSupport = true;
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Result Icon/Illustration
          Icon(
            Icons.analytics_outlined,
            size: 80.0,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 24.0),
          const Text(
            'Assessment Complete',
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2E3A59),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),

          // Dynamic Risk Card
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: cardBackground,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: textColor.withOpacity(0.2), width: 1.0),
            ),
            child: Column(
              children: [
                Text(
                  riskLevel.toUpperCase(),
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Color(0xFF2E3A59),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Spacer(),

          // Professional Support Hotline Button (High Risk only)
          if (showProfessionalSupport) ...[
            ElevatedButton(
              onPressed: () {
                _showHotlineDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC62828), // Supportive red
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: const Text('Talk to a Professional'),
            ),
            const SizedBox(height: 12.0),
          ],

          // Recovery button to go back to Dashboard
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: const Text('Back to Dashboard'),
          ),
          const SizedBox(height: 12.0),

          // Retake assessment button
          OutlinedButton(
            onPressed: _resetQuiz,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            child: const Text(
              'Retake Quiz',
              style: TextStyle(
                  color: Color(0xFF2E3A59), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showHotlineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text(
            'Professional Support',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF2E3A59)),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please know that help is always available. You are not alone in this.',
                style: TextStyle(fontSize: 15.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '• Call or Text: 988 (Crisis Lifeline, Free & Confidential, 24/7)',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
              ),
              SizedBox(height: 8.0),
              Text(
                '• Disaster Distress Helpline: 1-800-985-5990',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
              ),
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
}

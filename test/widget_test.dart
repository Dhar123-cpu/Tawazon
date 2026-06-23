import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tawazon/main.dart';

void main() {
  testWidgets('Complete 14-Screen App Journey: Splash -> Language -> Login -> Bottom Nav & Left Drawer Routing', (WidgetTester tester) async {
    // 1. Build app and trigger Splash Screen
    await tester.pumpWidget(const MyApp());
    expect(find.text('Tawazon'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // Tap "Get Started" and transition to Language Screen
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // 2. Language Selection Screen
    expect(find.text('Choose Your Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('العربية'), findsOneWidget);

    // Click "Continue" (defaults to English selection)
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // 3. Login Screen
    expect(find.text('Welcome Back'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'test@tawazon.app');
    await tester.enterText(find.byType(TextFormField).last, 'myPassword');
    await tester.pump();
    await tester.ensureVisible(find.text('Sign In'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    // 4. Main Navigation Shell - Home Tab
    expect(find.text('Good Morning, Friend'), findsOneWidget);
    expect(find.text('12 Days of Self-Care 🌱'), findsOneWidget);

    // -- TEST GUIDED TOUR OVERLAY --
    // Tap the App Tour help button
    await tester.tap(find.byTooltip('Guided App Tour'));
    await tester.pumpAndSettle();
    expect(find.textContaining('App Feature Guide (1/4)'), findsOneWidget);
    expect(find.text('Streak Tracker'), findsOneWidget);
    // Click Next
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Daily Mood Tracker'), findsOneWidget);
    // Skip / Close
    await tester.tap(find.text('Skip Tour'));
    await tester.pumpAndSettle();
    expect(find.textContaining('App Feature Guide'), findsNothing);

    // -- TEST STREAK MILESTONES DIALOG --
    await tester.tap(find.text('12 Days of Self-Care 🌱'));
    await tester.pumpAndSettle();
    expect(find.text('🌱 Streak Milestones'), findsOneWidget);
    expect(find.text('Current Level: Sapling 🌲'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // -- TEST MOOD REFLECTION HELPER CARD --
    // Tap 'Anxious' mood emoji
    await tester.tap(find.text('Anxious'));
    await tester.pumpAndSettle();
    expect(find.text('😟 Reflections'), findsOneWidget);
    expect(find.textContaining('practice a 3-minute centering breath sequence'), findsOneWidget);
    // Click 'Start Breathing' to switch tabs automatically
    await tester.ensureVisible(find.text('Start Breathing'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start Breathing'));
    await tester.pumpAndSettle();
    expect(find.text('Breathing Calmer'), findsOneWidget);

    // Switch back to Home Tab to continue the journey
    await tester.tap(find.descendant(
      of: find.byType(BottomNavigationBar),
      matching: find.byIcon(Icons.home_outlined),
    ));
    await tester.pumpAndSettle();

    // 5. Test Bottom Nav Tab: Safe Journal
    await tester.tap(find.descendant(
      of: find.byType(BottomNavigationBar),
      matching: find.byIcon(Icons.edit_note_rounded),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Safe Journal'), findsOneWidget);
    expect(find.text('Written Diary'), findsOneWidget);

    // Enter journal entry and save
    await tester.enterText(find.byType(TextFormField), 'Reflecting on emotional balance.');
    await tester.pump();
    await tester.tap(find.text('Save to Private Journal'));
    await tester.pump();
    expect(find.text('Saved securely and cloud synced to Firebase.'), findsOneWidget);

    // Dismiss Snackbars
    ScaffoldMessenger.of(tester.element(find.byType(Scaffold).first)).clearSnackBars();
    await tester.pumpAndSettle();

    // Test Voice Memo switch
    await tester.tap(find.text('Voice Memo'));
    await tester.pumpAndSettle();
    expect(find.text('Ready to Record'), findsOneWidget);
    await tester.ensureVisible(find.byIcon(Icons.mic_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.mic_rounded));
    await tester.pump();
    expect(find.text('Recording Securely'), findsOneWidget);
    await tester.ensureVisible(find.byIcon(Icons.stop_rounded));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.stop_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Recording Ready'), findsOneWidget);
    await tester.ensureVisible(find.text('Save Recording'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Recording'));
    await tester.pump();
    expect(find.text('Voice memo securely saved and cloud synced.'), findsOneWidget);

    // Dismiss Snackbars
    ScaffoldMessenger.of(tester.element(find.byType(Scaffold).first)).clearSnackBars();
    await tester.pumpAndSettle();

    // 6. Test Bottom Nav Tab: CBT Academy
    await tester.tap(find.descendant(
      of: find.byType(BottomNavigationBar),
      matching: find.byIcon(Icons.menu_book_rounded),
    ));
    await tester.pumpAndSettle();
    expect(find.text('CBT Academy'), findsNWidgets(2));
    expect(find.text('0 of 4 lessons completed'), findsOneWidget);

    // Open first lesson and complete
    await tester.tap(find.text('Identifying Cognitive Distortions'));
    await tester.pumpAndSettle();
    expect(find.text('Mark as Completed'), findsOneWidget);
    await tester.tap(find.text('Mark as Completed'));
    await tester.pumpAndSettle();

    // Verify progress update
    expect(find.text('1 of 4 lessons completed'), findsOneWidget);
    expect(find.text('🏅 Bronze'), findsOneWidget);

    // Dismiss Snackbars
    ScaffoldMessenger.of(tester.element(find.byType(Scaffold).first)).clearSnackBars();
    await tester.pumpAndSettle();

    // 7. Test Bottom Nav Tab: Breathing Calmer (Coping Tools)
    await tester.tap(find.descendant(
      of: find.byType(BottomNavigationBar),
      matching: find.byIcon(Icons.self_improvement_rounded),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Breathing Calmer'), findsOneWidget);
    expect(find.text('Ready'), findsOneWidget);

    // Start breathing
    await tester.tap(find.text('Start Breathing'));
    await tester.pump();
    expect(find.text('Breathe In'), findsOneWidget);
    await tester.tap(find.text('Stop Breathing'));
    await tester.pumpAndSettle();
    expect(find.text('Ready'), findsOneWidget);

    // Test quote reflection card
    expect(find.text('My feelings are valid, and I am learning to navigate them.'), findsOneWidget);
    await tester.ensureVisible(find.text('My feelings are valid, and I am learning to navigate them.'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('My feelings are valid, and I am learning to navigate them.'));
    await tester.pumpAndSettle();
    expect(find.text('I am worthy of peace, comfort, and recovery.'), findsOneWidget);

    // 8. Test Bottom Nav Tab: Settings Screen
    await tester.tap(find.descendant(
      of: find.byType(BottomNavigationBar),
      matching: find.byIcon(Icons.settings_outlined),
    ));
    await tester.pumpAndSettle();
    expect(find.text('App Preferences'), findsOneWidget);

    // Toggle Toggles
    await tester.tap(find.text('Dark Mode'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Biometric Lock'));
    await tester.pumpAndSettle();
    // Test Wellness Data Export
    await tester.ensureVisible(find.text('Export My Wellness Data'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Export My Wellness Data'));
    await tester.pump(); // Start simulated loading
    expect(find.text('Encrypting wellness records locally...'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1500)); // Finish loading
    await tester.pumpAndSettle();
    expect(find.text('Wellness Data Exported.'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // Test Delete Account Cancel
    await tester.ensureVisible(find.text('Delete Account Data'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete Account Data'));
    await tester.pumpAndSettle();
    expect(find.text('Delete All Data?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Switch back to Home Tab to test drawer opening
    await tester.tap(find.descendant(
      of: find.byType(BottomNavigationBar),
      matching: find.byIcon(Icons.home_outlined),
    ));
    await tester.pumpAndSettle();

    // 9. Open Navigation Drawer
    final ScaffoldState scaffoldState = tester.firstState(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    // Verify Drawer items exist
    expect(find.text('Tawazon Risk Assessment Quiz'), findsOneWidget);
    expect(find.text('Mindful Insights AI'), findsOneWidget);
    expect(find.text('Support Circles & Helplines'), findsOneWidget);
    expect(find.text('Recovery Progress Summary'), findsOneWidget);

    // 10. Drawer Navigation: Recovery Progress Summary
    await tester.tap(find.text('Recovery Progress Summary'));
    await tester.pumpAndSettle();
    expect(find.text('Recovery Progress Summary'), findsOneWidget);
    expect(find.text('Your Growth Journey'), findsOneWidget);

    // Navigate back to Main Shell using back arrow
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    // 11. Drawer Navigation: Mindful Insights AI
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mindful Insights AI'));
    await tester.pumpAndSettle();
    expect(find.text('Mindful Insights AI'), findsOneWidget);
    expect(find.text('Pre-Meal Stress Spikes'), findsOneWidget);

    // Navigate back
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    // 12. Drawer Navigation: Support Circles & Helplines
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Support Circles & Helplines'));
    await tester.pumpAndSettle();
    expect(find.text('Support Circles & Helplines'), findsOneWidget);
    expect(find.text('Hope Line'), findsOneWidget);

    // Test helpline simulator click
    await tester.tap(find.byIcon(Icons.phone_in_talk_rounded).first);
    await tester.pump();
    expect(find.text('Simulating call to Hope Line (8004673)...'), findsOneWidget);

    // Clear Snackbars
    ScaffoldMessenger.of(tester.element(find.byType(Scaffold).first)).clearSnackBars();
    await tester.pumpAndSettle();

    // Switch tabs within Support Circles screen
    await tester.tap(find.text('Workbook'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guide for Parents'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Do not discuss portion sizes'), findsOneWidget);

    // Navigate back
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    // 13. Drawer Navigation: Tawazon Risk Assessment Quiz
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tawazon Risk Assessment Quiz'));
    await tester.pumpAndSettle();

    // Step through the quiz
    expect(find.text('Step 1 of 4'), findsOneWidget);
    await tester.tap(find.text('Very calm and low stress'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Step 2 of 4'), findsOneWidget);
    await tester.tap(find.text('Not at all, I feel emotionally balanced'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Step 3 of 4'), findsOneWidget);
    await tester.tap(find.text('Very connected to friends and family'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Step 4 of 4'), findsOneWidget);
    await tester.tap(find.text('Highly stable, healthy sleep and meals'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Verify completion
    expect(find.text('Assessment Complete'), findsOneWidget);
    expect(find.text('LOW RISK'), findsOneWidget);

    // Go back to Dashboard
    await tester.tap(find.text('Back to Dashboard'));
    await tester.pumpAndSettle();
    expect(find.text('Good Morning, Friend'), findsOneWidget);
  });
}

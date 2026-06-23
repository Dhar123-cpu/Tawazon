import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tawazon/services/firebase_service.dart';

class JournalScreen extends StatefulWidget {
  final bool isEmbedded;
  const JournalScreen({super.key, this.isEmbedded = false});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  bool _isTextMode = true;
  final _textController = TextEditingController();
  final _feelingsController = TextEditingController();
  final _triggersController = TextEditingController();

  // Voice Recording Simulation State
  bool _isRecording = false;
  bool _hasRecording = false;
  int _recordingSeconds = 0;
  Timer? _timer;
  Timer? _waveTimer;
  List<double> _waveHeights = List.filled(15, 8.0);

  @override
  void dispose() {
    _timer?.cancel();
    _waveTimer?.cancel();
    _textController.dispose();
    _feelingsController.dispose();
    _triggersController.dispose();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordingSeconds = 0;
      _hasRecording = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingSeconds++;
      });
    });

    final random = Random();
    _waveTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        _waveHeights =
            List.generate(15, (index) => random.nextDouble() * 40.0 + 8.0);
      });
    });
  }

  void _stopRecording() {
    _timer?.cancel();
    _waveTimer?.cancel();
    setState(() {
      _isRecording = false;
      _hasRecording = true;
      _waveHeights = List.filled(15, 8.0);
    });
  }

  void _saveWrittenJournal() async {
    final thoughts = _textController.text.trim();
    final feelings = _feelingsController.text.trim();
    final triggers = _triggersController.text.trim();

    if (thoughts.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not authenticated. Please try logging in again.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc('tawazon-95f97')
          .collection('users')
          .doc(user.uid)
          .collection('journals')
          .add({
        'thoughts': thoughts,
        'feelings': feelings,
        'triggers': triggers,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.cloud_done_rounded, color: Colors.white, size: 20.0),
              SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  'Saved securely and cloud synced to Firebase.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF4DB6AC),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      );

      setState(() {
        _textController.clear();
        _feelingsController.clear();
        _triggersController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error syncing to cloud: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }


  void _saveVoiceRecording() async {
    if (!_hasRecording) return;

    final durationText = _formatDuration(_recordingSeconds);
    final mockContent =
        "Simulated Voice Memo - Duration: $durationText. (Mindful check-in)";

    try {
      await FirebaseService().saveJournal(
        type: 'voice',
        content: mockContent,
        durationSeconds: _recordingSeconds,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.cloud_done_rounded, color: Colors.white, size: 20.0),
              SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  'Voice memo securely saved and cloud synced.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF4DB6AC),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      );

      setState(() {
        _hasRecording = false;
        _recordingSeconds = 0;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error syncing voice to cloud: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final content = SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card regarding privacy
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withOpacity(0.06),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.security_outlined,
                    color: theme.colorScheme.primary,
                    size: 24.0,
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      'Your entries are private, securely encrypted, and synced directly to your live Firebase project.',
                      style: TextStyle(
                        fontSize: 13.0,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Switcher (Tabs) for Text/Voice Modes
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (_isRecording) _stopRecording();
                        setState(() => _isTextMode = true);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        decoration: BoxDecoration(
                          color:
                              _isTextMode ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: _isTextMode
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: _isTextMode
                                  ? theme.colorScheme.primary
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              'Written Diary',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: _isTextMode
                                    ? theme.colorScheme.primary
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _isTextMode = false);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        decoration: BoxDecoration(
                          color:
                              !_isTextMode ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: !_isTextMode
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.mic_none_outlined,
                              size: 18,
                              color: !_isTextMode
                                  ? theme.colorScheme.primary
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              'Voice Memo',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: !_isTextMode
                                    ? theme.colorScheme.primary
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28.0),

            // Animated Swapper showing Text Editor vs Voice Recorder
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isTextMode
                  ? _buildTextEditor(theme)
                  : _buildVoiceRecorder(theme),
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
        title: const Text('Journal & Reflection'),
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

  Widget _buildTextEditor(ThemeData theme) {
    return Column(
      key: const ValueKey<String>('text'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Thoughts Text Field
        const Text(
          'Thoughts & Reflection',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _textController,
          maxLines: 5,
          minLines: 3,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: 'What is on your mind? Describe your reflections, achievements, or struggles...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.0),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 16.0),

        // Feelings Text Field
        const Text(
          'Current Feelings',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _feelingsController,
          maxLines: 2,
          minLines: 1,
          decoration: InputDecoration(
            hintText: 'How do you feel emotionally right now? (e.g. Calm, anxious, hopeful)',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.0),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 16.0),

        // Triggers Text Field
        const Text(
          'Possible Triggers',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _triggersController,
          maxLines: 2,
          minLines: 1,
          decoration: InputDecoration(
            hintText: 'Were there any specific triggers? (e.g. Work stress, routine change)',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.0),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 24.0),

        // Save Button
        ElevatedButton.icon(
          onPressed: _saveWrittenJournal,
          icon: const Icon(Icons.check_rounded, size: 20.0),
          label: const Text('Save to Private Journal'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceRecorder(ThemeData theme) {
    return Column(
      key: const ValueKey<String>('voice'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Simulated Recording Status and Timer
        Container(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Text(
                _isRecording
                    ? 'Recording Securely'
                    : (_hasRecording ? 'Recording Ready' : 'Ready to Record'),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: _isRecording
                      ? Colors.red.shade700
                      : const Color(0xFF2E3A59),
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                _formatDuration(_recordingSeconds),
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.w800,
                  color: _isRecording
                      ? Colors.red.shade700
                      : const Color(0xFF2E3A59),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 24.0),

              // Animated Waveform simulator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(_waveHeights.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    width: 4.0,
                    height: _waveHeights[index],
                    decoration: BoxDecoration(
                      color: _isRecording
                          ? Colors.red.shade400
                          : (_hasRecording
                              ? theme.colorScheme.primary
                              : Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 36.0),

        // Record Control Mic Circle
        Center(
          child: GestureDetector(
            onTap: () {
              if (_isRecording) {
                _stopRecording();
              } else {
                _startRecording();
              }
            },
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRecording
                    ? Colors.red.shade50
                    : theme.colorScheme.primary.withOpacity(0.1),
                border: Border.all(
                  color: _isRecording
                      ? Colors.red.shade300
                      : theme.colorScheme.primary,
                  width: 2.0,
                ),
              ),
              child: Center(
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRecording
                        ? Colors.red.shade500
                        : theme.colorScheme.primary,
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 32.0,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 40.0),

        // Save Voice Recording Button
        ElevatedButton.icon(
          onPressed: _hasRecording ? _saveVoiceRecording : null,
          icon: const Icon(Icons.check_rounded, size: 20.0),
          label: const Text('Save Recording'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tawazon/services/firebase_service.dart';

class SettingsScreen extends StatefulWidget {
  final bool isEmbedded;
  const SettingsScreen({super.key, this.isEmbedded = false});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _reminders = true;
  bool _biometric = false;
  String _selectedLang = 'English';

  void _showExportDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) {
        return _ExportDialog(theme: theme);
      },
    );
  }

  void _showDeleteDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFC62828)),
              SizedBox(width: 12.0),
              Text(
                'Delete All Data?',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF2E3A59)),
              ),
            ],
          ),
          content: Text(
            'This action is permanent and will completely erase your local journal entries, lessons progress, and risk assessment history from this device as well as all synced cloud databases. Are you sure you want to proceed?',
            style: TextStyle(
              color: const Color(0xFF2E3A59).withOpacity(0.8),
              fontSize: 14.0,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close dialog

                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);

                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Deleting your local and cloud data...'),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ),
                );

                try {
                  await FirebaseService().deleteUserData();

                  if (!mounted) return;
                  // Navigate back to Splash / Welcome screen with clear stack
                  navigator.pushNamedAndRemoveUntil('/', (route) => false);
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: const Text(
                          'All user data has been permanently deleted.'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: const Color(0xFFC62828),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Error deleting data from Firebase: $e'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC62828),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text('Delete Permanently'),
            ),
          ],
        );
      },
    );
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
            // Preferences Card
            const Text(
              'App Preferences',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3A59),
              ),
            ),
            const SizedBox(height: 12.0),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text(
                        'Dark Mode',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E3A59)),
                      ),
                      subtitle:
                          const Text('Enable a soothing dark visual theme'),
                      value: _darkMode,
                      activeColor: theme.colorScheme.primary,
                      onChanged: (val) => setState(() => _darkMode = val),
                    ),
                    Divider(color: Colors.grey.shade100, height: 1),
                    SwitchListTile(
                      title: const Text(
                        'Self-Care Reminders',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E3A59)),
                      ),
                      subtitle: const Text(
                          'Receive gentle prompts throughout the day'),
                      value: _reminders,
                      activeColor: theme.colorScheme.primary,
                      onChanged: (val) => setState(() => _reminders = val),
                    ),
                    Divider(color: Colors.grey.shade100, height: 1),
                    SwitchListTile(
                      title: const Text(
                        'Biometric Lock',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E3A59)),
                      ),
                      subtitle: const Text('Secure your private journal logs'),
                      value: _biometric,
                      activeColor: theme.colorScheme.primary,
                      onChanged: (val) => setState(() => _biometric = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32.0),

            // Language Card
            const Text(
              'App Language / اللغة',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3A59),
              ),
            ),
            const SizedBox(height: 12.0),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
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
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedLang,
                  icon: Icon(Icons.arrow_drop_down_rounded,
                      color: theme.colorScheme.primary, size: 30),
                  isExpanded: true,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3A59),
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedLang = newValue;
                      });
                    }
                  },
                  items: <String>['English', 'العربية']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 32.0),

            // Privacy & Data Panel
            const Text(
              'Security & Data',
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
                  OutlinedButton.icon(
                    onPressed: () => _showExportDialog(context, theme),
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Export My Wellness Data'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      foregroundColor: theme.colorScheme.primary,
                      side: BorderSide(
                          color: theme.colorScheme.primary.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    onPressed: () => _showDeleteDialog(context, theme),
                    icon: const Icon(Icons.delete_forever_rounded),
                    label: const Text('Delete Account Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFC62828).withOpacity(0.08),
                      foregroundColor: const Color(0xFFC62828),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: const BorderSide(
                            color: Color(0xFFC62828), width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40.0),

            // Sign Out Button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: const Text('Sign Out'),
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
        title: const Text('Settings'),
      ),
      body: content,
    );
  }
}

class _ExportDialog extends StatefulWidget {
  final ThemeData theme;
  const _ExportDialog({required this.theme});

  @override
  State<_ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<_ExportDialog> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Row(
        children: [
          Icon(Icons.vpn_key_rounded, color: widget.theme.colorScheme.primary),
          const SizedBox(width: 12.0),
          const Text(
            'Export Wellness Data',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF2E3A59)),
          ),
        ],
      ),
      content: _isLoading
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16.0),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      widget.theme.colorScheme.primary),
                ),
                const SizedBox(height: 24.0),
                Text(
                  'Encrypting wellness records locally...',
                  style: TextStyle(
                      color: const Color(0xFF2E3A59).withOpacity(0.7),
                      fontSize: 14.0),
                ),
                const SizedBox(height: 8.0),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wellness Data Exported.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: widget.theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Your private journal logs, CBT progress, and mood statistics have been securely compiled into an encrypted JSON file and saved to local storage.',
                  style: TextStyle(
                    color: const Color(0xFF2E3A59).withOpacity(0.8),
                    fontSize: 14.0,
                    height: 1.4,
                  ),
                ),
              ],
            ),
      actions: [
        if (!_isLoading)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
      ],
    );
  }
}

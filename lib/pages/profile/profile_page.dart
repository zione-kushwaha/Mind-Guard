import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import '../../core/providers/app_providers.dart';
import 'report.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userPreferences = ref.watch(userPreferencesProvider);
    final highContrast = ref.watch(highContrastModeProvider);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Profile & Settings',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              
              // Profile Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Anonymous User',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your privacy is protected',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(height: 5,)
,
ElevatedButton(
  onPressed: () async {
   Navigator.push(context, MaterialPageRoute(builder: (context) => ReportView()));
  },
  child: Text("view detail report"),
)                  ],
                ),
              ),
              
              SizedBox(height: 24),
              
              // Settings Section
              _buildSettingsSection(
                context,
                theme,
                'Accessibility',
                [
                  _buildSettingsTile(
                    context,
                    theme,
                    'High Contrast Mode',
                    'Improve visibility for low-vision users',
                    Icons.contrast,
                    Switch(
                      value: highContrast,
                      onChanged: (value) {
                        ref.read(highContrastModeProvider.notifier).state = value;
                      },
                    ),
                  ),
                  _buildSettingsTile(
                    context,
                    theme,
                    'Text-to-Speech',
                    'Enable voice guidance for exercises',
                    Icons.record_voice_over,
                    Switch(
                      value: userPreferences['textToSpeech'] ?? false,
                      onChanged: (value) {
                        ref.read(userPreferencesProvider.notifier).updatePreference('textToSpeech', value);
                      },
                    ),
                  ),
                  _buildSettingsTile(
                    context,
                    theme,
                    'Voice Commands',
                    'Control app with voice',
                    Icons.mic,
                    Switch(
                      value: false,
                      onChanged: (value) {
                        // TODO: Implement voice commands
                      },
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              // Emergency Settings
              _buildSettingsSection(
                context,
                theme,
                'Emergency Support',
                [
                  _buildSettingsTile(
                    context,
                    theme,
                    'Emergency Contacts',
                    'Manage your trusted contacts',
                    Icons.emergency,
                    Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showEmergencyContacts(context),
                  ),
                  _buildSettingsTile(
                    context,
                    theme,
                    'Location Sharing',
                    'Share location with trusted contacts',
                    Icons.location_on,
                    Switch(
                      value: false,
                      onChanged: (value) {
                        // TODO: Implement location sharing
                      },
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              // Privacy Settings
              _buildSettingsSection(
                context,
                theme,
                'Privacy & Security',
                [
                  _buildSettingsTile(
                    context,
                    theme,
                    'App Lock',
                    'Secure app with PIN or biometrics',
                    Icons.lock,
                    Switch(
                      value: false,
                      onChanged: (value) {
                        // TODO: Implement app lock
                      },
                    ),
                  ),
                  _buildSettingsTile(
                    context,
                    theme,
                    'Anonymous Mode',
                    'Use app without personal data',
                    Icons.visibility_off,
                    Switch(
                      value: true,
                      onChanged: (value) {
                        // TODO: Implement anonymous mode
                      },
                    ),
                  ),
                  _buildSettingsTile(
                    context,
                    theme,
                    'Data Export',
                    'Export your data',
                    Icons.download,
                    Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showDataExport(context),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              // App Info
              _buildSettingsSection(
                context,
                theme,
                'About',
                [
                  _buildSettingsTile(
                    context,
                    theme,
                    'App Version',
                    'MindGuard v1.0.0',
                    Icons.info,
                    SizedBox(),
                  ),
                  _buildSettingsTile(
                    context,
                    theme,
                    'Privacy Policy',
                    'Read our privacy policy',
                    Icons.policy,
                    Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showPrivacyPolicy(context),
                  ),
                  _buildSettingsTile(
                    context,
                    theme,
                    'Support',
                    'Get help and support',
                    Icons.help,
                    Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showSupport(context),
                  ),
                ],
              ),
              
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, ThemeData theme, String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    ThemeData theme,
    String title,
    String subtitle,
    IconData icon,
    Widget trailing, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            trailing,
          ],
        ),
      ),
    );
  }

  void _showEmergencyContacts(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Emergency Contacts'),
        content: Text('Emergency contacts feature will be implemented with secure storage.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDataExport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Data Export'),
        content: Text('Your data will be exported in a secure format.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement data export
            },
            child: Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Text(
            'MindGuard Privacy Policy\n\n'
            'Your privacy is our priority. This app:\n\n'
            '• Stores all data locally on your device\n'
            '• Uses end-to-end encryption\n'
            '• Never shares your personal information\n'
            '• Operates in anonymous mode by default\n'
            '• Gives you full control over your data\n\n'
            'For more information, visit our website.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Get help with:'),
            SizedBox(height: 8),
            Text('• Using app features'),
            Text('• Technical issues'),
            Text('• Accessibility options'),
            Text('• Crisis support resources'),
            SizedBox(height: 16),
            Text('Contact: support@mindguard.app'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

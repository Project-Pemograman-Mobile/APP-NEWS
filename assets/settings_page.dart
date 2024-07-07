import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true; // Contoh pengaturan notifikasi
  bool _autoRefreshEnabled = true; // Contoh pengaturan auto refresh

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text('Enable Notifications'),
            subtitle: Text('Receive notifications for breaking news'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          Divider(),
          SwitchListTile(
            title: Text('Auto Refresh'),
            subtitle: Text('Automatically refresh news feed'),
            value: _autoRefreshEnabled,
            onChanged: (value) {
              setState(() {
                _autoRefreshEnabled = value;
              });
            },
          ),
          Divider(),
          ListTile(
            title: Text('Feedback'),
            onTap: () {
              // Implement feedback feature here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text('Privacy Policy'),
            onTap: () {
              // Implement privacy policy page navigation
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Center(
        child: Text('This is the Feedback page'),
      ),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: Center(
        child: Text('This is the Privacy Policy page'),
      ),
    );
  }
}

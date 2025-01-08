import 'package:flutter/material.dart';
import 'package:fyp/utils/colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Initial toggle states for each notification type
  bool emailNotification = true;
  bool smsNotification = false;
  bool salesNotification = true;
  bool newArrivalsNotification = false;
  bool deliveryStatusNotification = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Placeholder for notification icon action (optional)
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and icon for the settings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notification Settings',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.notifications, size: 30),
              ],
            ),
            const SizedBox(height: 20),

            // Email Notification
            _buildNotificationSetting(
              title: 'Email Notifications',
              icon: Icons.email,
              value: emailNotification,
              onChanged: (value) {
                setState(() {
                  emailNotification = value;
                });
              },
            ),

            // SMS Notification
            _buildNotificationSetting(
              title: 'SMS Notifications',
              icon: Icons.sms,
              value: smsNotification,
              onChanged: (value) {
                setState(() {
                  smsNotification = value;
                });
              },
            ),

            // Sales Notification
            _buildNotificationSetting(
              title: 'Sales Notifications',
              icon: Icons.local_offer,
              value: salesNotification,
              onChanged: (value) {
                setState(() {
                  salesNotification = value;
                });
              },
            ),

            // New Arrivals Notification
            _buildNotificationSetting(
              title: 'New Arrivals Notifications',
              icon: Icons.new_releases,
              value: newArrivalsNotification,
              onChanged: (value) {
                setState(() {
                  newArrivalsNotification = value;
                });
              },
            ),

            // Delivery Status Notification
            _buildNotificationSetting(
              title: 'Delivery Status Notifications',
              icon: Icons.local_shipping,
              value: deliveryStatusNotification,
              onChanged: (value) {
                setState(() {
                  deliveryStatusNotification = value;
                });
              },
            ),

            const Spacer(),

            // Update Button
            ElevatedButton(
              onPressed: () {
                // Handle Update action (e.g., save changes, send data to server)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Notification settings updated!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: bg_dark, // Dark blue color
                padding: const EdgeInsets.symmetric(vertical: 5),
              ),
              child: const Text('Update', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build each notification setting item
  Widget _buildNotificationSetting({
    required String title,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: bg_dark),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: bg_dark, // Dark blue color for the switch
          ),
        ],
      ),
    );
  }
}

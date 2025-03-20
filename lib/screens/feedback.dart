import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/utils/colors.dart';

class SendFeedbackPage extends StatefulWidget {
  const SendFeedbackPage({super.key});

  @override
  _SendFeedbackPageState createState() => _SendFeedbackPageState();
}

class _SendFeedbackPageState extends State<SendFeedbackPage> {
  int? selectedEmojiIndex;
  final TextEditingController feedbackController = TextEditingController();

  // Firestore instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Function to submit feedback
  void submitFeedback() async {
    String feedbackText = feedbackController.text.trim();

    if (feedbackText.isEmpty || selectedEmojiIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter feedback and select an emoji!')),
      );
      return;
    }

    try {
      await firestore.collection('feedback').add({
        'feedback': feedbackText,
        'rating': selectedEmojiIndex, // 0 = Horrible, 1 = Was Ok, 2 = Brilliant
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear inputs after submission
      feedbackController.clear();
      setState(() {
        selectedEmojiIndex = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Feedback'),
        backgroundColor: bg_dark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'asset/feedback.png',
              height: 250,
              width: 250,
            ),
            const SizedBox(height: 20),
            const Text(
              "We'd love to hear your thoughts",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 15),
            const Text(
              "Your feedback is important to us! Please share your experience.",
              style: TextStyle(fontSize: 13, color: Colors.black, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Emoji Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                emojiButton(0, Icons.sentiment_very_dissatisfied, 'Horrible'),
                const SizedBox(width: 20),
                emojiButton(1, Icons.sentiment_neutral, 'Was Ok'),
                const SizedBox(width: 20),
                emojiButton(2, Icons.sentiment_very_satisfied, 'Brilliant'),
              ],
            ),
            const SizedBox(height: 20),

            // Feedback Text Field
            TextField(
              controller: feedbackController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Type your feedback here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Feedback Button
            ElevatedButton(
              onPressed: submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: bg_dark,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Share your feedback',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  // Emoji Button Widget
  Widget emojiButton(int index, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEmojiIndex = index;
        });
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedEmojiIndex == index ? bg_dark : Colors.transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(icon, size: 60, color: Colors.amber),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: selectedEmojiIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

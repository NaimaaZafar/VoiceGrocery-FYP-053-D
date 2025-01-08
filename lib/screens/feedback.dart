import 'package:flutter/material.dart';
import 'package:fyp/utils/colors.dart';

class SendFeedbackPage extends StatefulWidget {
  const SendFeedbackPage({super.key});

  @override
  _SendFeedbackPageState createState() => _SendFeedbackPageState();
}

class _SendFeedbackPageState extends State<SendFeedbackPage> {
  // Track the selected emoji
  int? selectedEmojiIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Feedback'),
        backgroundColor: bg_dark, // Set app bar color if needed
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image symbol at the top
            Image.asset(
              'assets/feedback_icons.jpg', // Replace with your feedback icon image path
              height: 250, // Adjust size as needed
              width: 250, // Adjust size as needed
            ),
            const SizedBox(height: 20),

            // Text "We'd love to hear your thoughts" in big bold black
            const Text(
              "We'd love to hear your thoughts",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),

            // Additional description text in small black text
            const Text(
              "Your feedback is important to us! It helps us improve and provide better service. Please let us know your thoughts about our app, your experience, and any suggestions you may have for improvement. We value your input and strive to make this app better for you.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
                height: 1.5, // Adjust line height for readability
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Emojis row: Horrible, Was Ok, Brilliant with text underneath
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Horrible Emoji
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedEmojiIndex = 0; // Update the selected emoji index
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedEmojiIndex == 0
                                ? bg_dark
                                : Colors
                                .transparent, // Highlight border if selected
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.sentiment_very_dissatisfied,
                          size: 60,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Horrible',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: selectedEmojiIndex == 0
                              ? FontWeight.bold
                              : FontWeight.normal, // Make text bold if selected
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),

                // Was Ok Emoji
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedEmojiIndex = 1; // Update the selected emoji index
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedEmojiIndex == 1
                                ? bg_dark
                                : Colors
                                .transparent, // Highlight border if selected
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.sentiment_neutral,
                          size: 60,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Was Ok',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: selectedEmojiIndex == 1
                              ? FontWeight.bold
                              : FontWeight.normal, // Make text bold if selected
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),

                // Brilliant Emoji
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedEmojiIndex = 2; // Update the selected emoji index
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedEmojiIndex == 2
                                ? bg_dark
                                : Colors
                                .transparent, // Highlight border if selected
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.sentiment_very_satisfied,
                          size: 60,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Brilliant',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: selectedEmojiIndex == 2
                              ? FontWeight.bold
                              : FontWeight.normal, // Make text bold if selected
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // "Share your feedback" button
            ElevatedButton(
              onPressed: () {
                // Handle feedback submission action here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thank you for your feedback!')),
                );
                // Example: Submit feedback or navigate
                // Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: bg_dark, // Dark blue button color
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
      backgroundColor:
      Colors.white, // Set the background color of the page to white
    );
  }
}

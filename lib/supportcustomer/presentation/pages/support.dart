import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  bool chatStarted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          children: [
            Text(
              "MoneyMate Support",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 19,
              ),
            ),
            SizedBox(width: 7),
            CircleAvatar(
              radius: 5,
              backgroundColor: Colors.green,
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade200,
            height: 1,
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
              children: [
                Center(
                  child: Text(
                    "Today, 5 Aug 2026",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                _botMessage(
                  message:
                      "Hello! 👋 Welcome to MoneyMate Support.\nI'm here to assist you.",
                ),

                const SizedBox(height: 18),

                _botMessage(
                  message:
                      "Can you specify the issue you're facing?",
                  options: [
                    "Payment Issue",
                    "Money not received",
                    "Account Issue",
                    "Other",
                  ],
                ),

                if (chatStarted) ...[
                  const SizedBox(height: 18),

                  _userMessage(
                    "I need help with my payment.",
                  ),

                  const SizedBox(height: 18),

                  _botMessage(
                    message:
                        "Sure! I'll help you with that. Please choose one of the options below.",
                    options: [
                      "Payment failed",
                      "Payment pending",
                      "Refund issue",
                    ],
                  ),
                ],
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Still have an issue?",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 8),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      chatStarted = true;
                    });
                  },
                  child: const Text(
                    "Chat with us",
                    style: TextStyle(
                      color: Color(0xFF7B2CBF),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _botMessage({
    required String message,
    List<String>? options,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "MoneyMate",
              style: TextStyle(
                color: Color(0xFF7B2CBF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              message,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                height: 1.4,
              ),
            ),

            if (options != null) ...[
              const SizedBox(height: 15),

              ...options.map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _optionButton(option),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _optionButton(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.black45,
          ),
        ],
      ),
    );
  }

  Widget _userMessage(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 280,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF7B2CBF),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
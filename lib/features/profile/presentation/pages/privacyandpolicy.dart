import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const String appName = "Money Mate";
  static const String contactEmail = "moneymate2026@gmail.com"; 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Privacy Policy",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
          
          
            const SizedBox(height: 20),

            _section(
              context,
              "1. Introduction",
              " MoneyMate respects your privacy and is "
                  "committed to protecting it through this Privacy Policy. This "
                  "policy explains what information we collect, how we use it, "
                  "and the choices you have regarding your data when you use "
                  "our app.",
            ),

            _section(
              context,
              "2. Information We Collect",
              "• Account information: name, email address, and login credentials.\n"
                  "• Financial data you enter: transactions, budgets, categories, "
                  "and balances you manually add or import.\n"
                  "• Device information: device type, operating system, and app "
                  "usage analytics.\n"
                  "• We do NOT collect or request access to your actual bank "
                  "account credentials unless you explicitly connect a bank "
                  "account through a supported integration.",
            ),

            _section(
              context,
              "3. How We Use Your Information",
              "We use the collected data to:\n"
                  "• Provide and maintain the app's core functionality.\n"
                  "• Sync your data securely across your devices.\n"
                  "• Improve app performance and user experience.\n"
                  "• Send important updates about your account or the app "
                  "(not marketing, unless you opt in).",
            ),

            _section(
              context,
              "4. Data Storage & Security",
              "Your data is stored securely using industry-standard encryption "
                  "both in transit and at rest. We implement reasonable "
                  "administrative, technical, and physical safeguards to "
                  "protect your information from unauthorized access, "
                  "alteration, or disclosure.",
            ),

            _section(
              context,
              "5. Data Sharing",
              "We do not sell, rent, or trade your personal or financial "
                  "information to third parties. We may share data only:\n"
                  "• With service providers who help us operate the app "
                  "(e.g., cloud hosting), under strict confidentiality "
                  "agreements.\n"
                  "• When required by law or to protect our legal rights.",
            ),

            _section(
              context,
              "6. Your Rights & Choices",
              "You may:\n"
                  "• Access, update, or delete your account data at any time "
                  "from within the app.\n"
                  "• Request a copy of your data by contacting us.\n"
                  "• Delete your account, which will permanently remove your "
                  "data from our servers within a reasonable period.",
            ),

            _section(
              context,
              "7. Children's Privacy",
              "This app is not intended for children under 13. We do not "
                  "knowingly collect personal information from children.",
            ),

            _section(
              context,
              "8. Changes to This Policy",
              "We may update this Privacy Policy from time to time. Changes "
                  "will be reflected by updating the \"Last updated\" date "
                  "at the top of this page.",
            ),

            _section(
              context,
              "9. Contact Us",
              "If you have any questions about this Privacy Policy, please "
                  "contact us at $contactEmail.",
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
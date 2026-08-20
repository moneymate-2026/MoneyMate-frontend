import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/core/theme/theme_controller.dart';

import 'package:flutter_application_1/features/wallet/presentation/pages/transaction_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SendMoneyPage extends ConsumerStatefulWidget {
  const SendMoneyPage({super.key});

  @override
  ConsumerState<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends ConsumerState<SendMoneyPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController(
    text: "500",
  );

  int _selectedCategory = -1;
  int _selectedContactIndex = -1;

  // TODO(API): Replace with GET /contacts/recent
  final List<Map<String, dynamic>> _contacts = const [
    {
      "initials": "AR",
      "name": "Arun Raj",
      "handle": "@arunraj",
      "bg": Colors.green,
    },
    {
      "initials": "FA",
      "name": "Fathima",
      "handle": "@fathima12",
      "bg": Colors.green,
    },
    {"initials": "AS", "name": "Aslam", "handle": "@aslam01", "bg": Colors.red},
    {
      "initials": "Nk",
      "name": "Nikhil",
      "handle": "@nikhil07",
      "bg": Colors.red,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _onSendMoney() async {
    final token = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const TransactionPinPage()),
    );
    if (token == null) return;
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final bool isDark = themeMode == ThemeMode.dark;
    final bool isContactSelected = _selectedContactIndex != -1;

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(isDark),
            const SizedBox(height: 24),
            _buildRecentContactsHeader(),
            const SizedBox(height: 12),
            _buildRecentContacts(isDark),
            if (isContactSelected) ...[
              const SizedBox(height: 24),
              const Text(
                "Enter Amount",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildAmountField(isDark),
              const SizedBox(height: 24),
              const Text(
                "Category (Optional)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildCategoryGrid(isDark),
              const SizedBox(height: 28),
              _buildSendButton(),
              const SizedBox(height: 16),
              _buildSecureNote(isDark),
            ],
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const BackButton(),
      title: const Text("Sent Money"),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.person_outline, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return TextField(
      controller: _searchController,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: "Enter name, phone number or UPI ID",
        hintStyle: TextStyle(
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
        ),
        suffixIcon: Icon(
          Icons.fullscreen,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
        ),
        filled: true,
        fillColor: isDark ? Bkcolors.darkcardcolor : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? Bkcolors.darkbordercolor
                : Bkcolors.lightbordercolor,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentContactsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Recent Contacts",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        TextButton(onPressed: () {}, child: const Text("View All")),
      ],
    );
  }

  
  Widget _buildRecentContacts(bool isDark) {
    return Row(
      children: List.generate(_contacts.length, (index) {
        final contact = _contacts[index];
        final Color baseColor = contact["bg"] as Color;
        return _buildContactAvatar(
          index: index,
          initials: contact["initials"] as String,
          name: contact["name"] as String,
          handle: contact["handle"] as String,
          bg: baseColor,
          fg: baseColor,
          isDark: isDark,
        );
      }),
    );
  }

  Widget _buildContactAvatar({
    required int index,
    required String initials,
    required String name,
    required String handle,
    required Color bg,
    required Color fg,
    required bool isDark,
  }) {
    final bool isSelected = _selectedContactIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedContactIndex = _selectedContactIndex == index ? -1 : index;
          });
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: bg,
              child: Text(
                initials,
                style: TextStyle(color: fg, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? fg : (isDark ? Colors.white : Colors.black),
              ),
            ),
            Text(
              handle,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountField(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Bkcolors.darkcardcolor : Colors.white,
        border: Border.all(
          color: isDark ? Bkcolors.darkbordercolor : Bkcolors.lightbordercolor,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(
            "₹",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          IconButton(
            onPressed: () => _amountController.clear(),
            icon: Icon(
              Icons.close,
              size: 18,
              color: isDark ? Colors.grey.shade400 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // TODO(API): Replace with GET /categories
  Widget _buildCategoryGrid(bool isDark) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 8,
      children: [
        _buildCategoryItem(0, Icons.restaurant, "Food", Colors.orange, isDark),
        _buildCategoryItem(
          1,
          Icons.shopping_bag,
          "Shopping",
          Colors.pink,
          isDark,
        ),
        _buildCategoryItem(
          2,
          Icons.directions_bus,
          "Transport",
          Colors.blue,
          isDark,
        ),
        _buildCategoryItem(3, Icons.receipt, "Bills", Colors.amber, isDark),
        _buildCategoryItem(
          4,
          Icons.movie,
          "Entertainment",
          Colors.purple,
          isDark,
        ),
        _buildCategoryItem(5, Icons.favorite, "Health", Colors.teal, isDark),
        _buildCategoryItem(6, Icons.school, "Education", Colors.indigo, isDark),
        _buildCategoryItem(7, Icons.more_horiz, "Others", Colors.grey, isDark),
      ],
    );
  }

  Widget _buildCategoryItem(
    int index,
    IconData icon,
    String label,
    Color color,
    bool isDark,
  ) {
    final bool isSelected = _selectedCategory == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = index),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? color.withOpacity(0.25) : color.withOpacity(0.15),
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: color, width: 2) : null,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.grey.shade300 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _onSendMoney,

        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Send Money",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildSecureNote(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.green.shade900.withOpacity(0.25)
            : Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shield_outlined,
            color: isDark ? Colors.green.shade300 : Colors.green.shade700,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Secure & Instant Transfers",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  "Your money is safe with end-to-end encryption",
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey.shade300 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

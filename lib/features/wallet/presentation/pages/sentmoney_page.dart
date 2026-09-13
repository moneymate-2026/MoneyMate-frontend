
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/core/theme/theme_controller.dart';
import 'package:flutter_application_1/features/qr_scanner/presentation/pages/models/transfer_razo_model.dart';
import 'package:flutter_application_1/features/qr_scanner/presentation/repositeries/resolve_get.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/data/repositeries/transaction_getting.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/data/repositeries/userget_num.dart';
import 'package:flutter_application_1/features/qr_scanner/presentation/pages/models/paymentcat.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/paymentsucceful_page.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/transaction_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SendMoneyPage extends ConsumerStatefulWidget {
  const SendMoneyPage({super.key});

  @override
  ConsumerState<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends ConsumerState<SendMoneyPage> {
Future<void> _editCategory(String categoryId, String currentName) async {
  final controller = TextEditingController(text: currentName);

  final newName = await showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Edit Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter category name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = controller.text.trim();

              if (value.isEmpty) return;

              Navigator.pop(dialogContext, value);
            },
            child: const Text('Update'),
          ),
        ],
      );
    },
  );

  controller.dispose();

  if (newName == null || newName.isEmpty) {
    return;
  }

  await updatePaymentCategory(categoryId, newName);
  if (!mounted) return;

await _loadCategories();
}


   Future<void> _deleteCategory(String categoryId) async {
  try {
    await deletePaymentCategory(categoryId);

    if (!mounted) return;

    await _loadCategories();
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to delete category: $e'),
      ),
    );
  }
}

    Future<void> _showCategoryMenu(
  String categoryId,
  String currentName,
) async {
  final action = await showModalBottomSheet<String>(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(sheetContext, 'edit');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(sheetContext, 'delete');
              },
            ),
          ],
        ),
      );
    },
  );

  if (!mounted) return;

  if (action == 'edit') {
    await _editCategory(categoryId, currentName);
  }

  if (action == 'delete') {
        await _deleteCategory(categoryId);
  }
}



  Future<void> _loadContacts() async {
    try {
      setState(() {
        _isLoadingContacts = true;
      });

      final transactionService = Gettransinfo();

      final transactions = await transactionService.getMyTransactions();
      if (!mounted) return;

      final List<Map<String, dynamic>> contacts = [];

      for (final transaction in transactions) {
        final from = transaction['from'];
        final to = transaction['to'];

        if (from != null) {
          contacts.add(Map<String, dynamic>.from(from));
        }

        if (to != null) {
          contacts.add(Map<String, dynamic>.from(to));
        }
      }

      setState(() {
        _contacts = contacts;
        _isLoadingContacts = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingContacts = false;
      });

      debugPrint('Contacts Error: $e');
    }
  }

  Future<void> _loadCategories() async {
    try {
      setState(() {
        _isLoadingCategories = true;
      });

      final categories = await getPaymentCategories();

      if (!mounted) return;

      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingCategories = false;
      });

      debugPrint('Category Error: $e');
    }
  }

  Future<void> _searchUser() async {
    final phone = _searchController.text.trim();

    if (phone.isEmpty) {
      return;
    }

    try {
      setState(() {
        _isSearching = true;
        _selectedUser = null;
      });

      final user = await lookupuser(phone);

      if (!mounted) return;

      setState(() {
        _selectedUser = user;
        _isSearching = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSearching = false;
        _selectedUser = null;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('User not found')));
    }
  }

  Map<String, dynamic>? _selectedUser;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController(
    text: "500",
  );

  String? _selectedCategoryId;
  List<PaymentCategoryModel> _categories = [];
  bool _isLoadingCategories = false;
  int _selectedContactIndex = -1;
  List<Map<String, dynamic>> _contacts = [];
  bool _isLoadingContacts = false;
  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadContacts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _onSendMoney() async {
    if (_selectedUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a recipient')),
      );
      return;
    }

    if (_amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter amount')));
      return;
    }

    final token = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const TransactionPinPage()),
    );

    if (token == null) return;

    try {
      final transfer = Transferrazomodel(
        toHandle: _selectedUser!['handle'].toString(),
        amount: _amountController.text.trim(),
        idempotencyKey: DateTime.now().microsecondsSinceEpoch.toString(),
        description: 'Money transfer',
        categoryId: _selectedCategoryId ?? '',
        transactionToken: token,
      );

      await createtransfer(transfer);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessPage(
            amount: double.parse(_amountController.text.trim()),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    }
  }

  Future<void> _showAddCategoryDialog() async {
    final controller = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Add Category"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter category name",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final value = controller.text.trim();

                if (value.isEmpty) {
                  return;
                }

                Navigator.pop(dialogContext, value);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
    await Future.delayed(const Duration(milliseconds: 500));
    controller.dispose();

    if (name == null || name.isEmpty) {
      return;
    }

    try {
      await createPaymentCategory(name);

      if (!mounted) return;

      await Future.delayed(const Duration(milliseconds: 100));

      if (!mounted) return;

      await _loadCategories();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category added successfully")),
      );
    } catch (e) {
      if (!mounted) return;
    }
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

            if (_selectedUser != null) ...[
              const SizedBox(height: 20),
              _buildSearchedUser(isDark),
            ],
            const SizedBox(height: 24),
            _buildRecentContactsHeader(),
            const SizedBox(height: 12),
            _buildRecentContacts(isDark),
            if (_selectedUser != null || isContactSelected) ...[
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
              _buildCategoryField(isDark),
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
      keyboardType: TextInputType.phone,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _searchUser(),
      decoration: InputDecoration(
        hintText: "Enter phone number or UPI ID",
        hintStyle: TextStyle(
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
        ),
        suffixIcon: _isSearching
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _searchUser,
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
    if (_isLoadingContacts) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_contacts.isEmpty) {
      return const Text("No recent contacts", style: TextStyle(fontSize: 14));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_contacts.length, (index) {
          final contact = _contacts[index];

          final String name =
              contact['full_name']?.toString() ??
              contact['username']?.toString() ??
              'Unknown';

          final String handle = contact['handle']?.toString() ?? '';

          final String initials = name.isNotEmpty
              ? name.substring(0, 1).toUpperCase()
              : '?';

          final Color bg = Colors.deepPurple.shade100;
          final Color fg = Colors.deepPurple;

          return SizedBox(
            width: 85,
            child: _buildContactAvatar(
              index: index,
              initials: initials,
              name: name,
              handle: handle,
              bg: bg,
              fg: fg,
              isDark: isDark,
            ),
          );
        }),
      ),
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

    return GestureDetector(
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
    );
  }

  Widget _buildSearchedUser(bool isDark) {
    final user = _selectedUser!;

    final String name = user['full_name']?.toString() ?? 'Unknown User';
    final String handle = user['handle']?.toString() ?? '';
    final String phone = user['phone']?.toString() ?? '';

    final String initial = name.isNotEmpty
        ? name.substring(0, 1).toUpperCase()
        : '?';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Bkcolors.darkcardcolor : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Bkcolors.primarycolor, width: 1.5),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Bkcolors.primarycolor,
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  handle,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  phone,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const Icon(Icons.check_circle, color: Colors.green, size: 24),
        ],
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
Widget _buildCategoryField(bool isDark) {
  if (_isLoadingCategories) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: _categories.length + 1,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.85,
    ),
    itemBuilder: (context, index) {
      if (index == _categories.length) {
        return GestureDetector(
          onTap: _showAddCategoryDialog,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.deepPurple,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Add',
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
        );
      }

      final category = _categories[index];

      return _buildCategoryItem(
        index,
        Icons.category_outlined,
        category.name,
        Colors.deepPurple,
        isDark,
        category.id,
      );
    },
  );
}
  Widget _buildCategoryItem(
    int index,
    IconData icon,
    String label,
    Color color,
    bool isDark,
    String categoryId,
  ) {
    final bool isSelected = _selectedCategoryId == categoryId;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryId = categoryId;
        });
      },
      onDoubleTap:(){
           _showCategoryMenu(categoryId, label);
      } ,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? color.withOpacity(0.25)
                      : color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: color, width: 2)
                      : null,
                ),
                child: Icon(icon, color: color),
              ),


            ],
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

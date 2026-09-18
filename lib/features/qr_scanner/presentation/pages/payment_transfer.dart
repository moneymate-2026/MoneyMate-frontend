import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';

import 'package:flutter_application_1/features/qr_scanner/presentation/pages/models/paymentcat.dart';
import 'package:flutter_application_1/features/qr_scanner/presentation/pages/models/paymentresolve_model.dart';
import 'package:flutter_application_1/features/qr_scanner/presentation/pages/pinentry_trans.dart';
import 'package:flutter_application_1/features/qr_scanner/presentation/repositeries/resolve_get.dart';

class PaymentPage extends StatefulWidget {
  final Resolveaccount account;

  const PaymentPage({
    super.key,
    required this.account,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final amountController = TextEditingController();
  final labelController = TextEditingController();

  List<PaymentCategoryModel> categories = [];
  PaymentCategoryModel? selectedCategory;

  bool loading = true;
  bool creating = false;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final data = await getPaymentCategories();

      if (!mounted) return;

      setState(() {
        categories = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      showMessage('Failed to load labels');
    }
  }

  Future<void> createLabel(BuildContext dialogContext) async {
    final name = labelController.text.trim();

    if (name.isEmpty) {
      showMessage('Enter a label name');
      return;
    }

    setState(() {
      creating = true;
    });

    try {
      await createPaymentCategory(name);

      final data = await getPaymentCategories();

      if (!mounted) return;

      PaymentCategoryModel? newCategory;

      for (final category in data) {
        if (category.name.toLowerCase() == name.toLowerCase()) {
          newCategory = category;
          break;
        }
      }

      setState(() {
        categories = data;
        selectedCategory = newCategory;
        creating = false;
      });

      labelController.clear();

      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);
      }

      showMessage('$name created');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        creating = false;
      });

      debugPrint('CREATE LABEL ERROR: $e');

      showMessage('Failed to create label');
    }
  }

  void showCreateLabel() {
    labelController.clear();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Bkcolors.darkcardcolor,
        title: const Text(
          'Create Label',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: labelController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'e.g. Rent',
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: creating
                ? null
                : () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: creating
                ? null
                : () => createLabel(dialogContext),
            child: creating
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> continuePayment() async {
    final amount = double.tryParse(
      amountController.text.trim(),
    );

    if (amount == null || amount <= 0) {
      showMessage('Enter a valid amount');
      return;
    }

    if (selectedCategory == null) {
      showMessage('Select a label');
      return;
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PinEntryPage(
          toHandle: widget.account.handle,
          amount: amount,
          categoryId: selectedCategory!.id,
          receiverName: widget.account.displayname.isNotEmpty
              ? widget.account.displayname
              : widget.account.handle,
        ),
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Bkcolors.scaffoldbackground,

      appBar: AppBar(
        backgroundColor: Bkcolors.scaffoldbackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Send Money',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Payment To',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 10),

            // Receiver
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Bkcolors.darkcardcolor,
                borderRadius: BorderRadius.circular(18),
              ),

              child: Row(
                children: [

                  CircleAvatar(
                    radius: 27,
                    backgroundColor:
                        Colors.deepPurple.withOpacity(.3),

                    backgroundImage:
                        widget.account.image.isNotEmpty
                            ? NetworkImage(widget.account.image)
                            : null,

                    child: widget.account.image.isEmpty
                        ? const Icon(
                            Icons.person,
                            color: Colors.white,
                          )
                        : null,
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          widget.account.displayname.isNotEmpty
                              ? widget.account.displayname
                              : widget.account.handle,

                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          widget.account.handle,
                          style: const TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Amount',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: amountController,

              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),

              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),

              decoration: InputDecoration(
                prefixText: '₹ ',

                prefixStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                ),

                hintText: '0.00',

                hintStyle: const TextStyle(
                  color: Colors.white24,
                ),

                filled: true,
                fillColor: Bkcolors.darkcardcolor,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [

                const Text(
                  'Payment Label',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),

                TextButton.icon(
                  onPressed: showCreateLabel,

                  icon: const Icon(
                    Icons.add,
                    size: 18,
                  ),

                  label: const Text(
                    'Add Label',
                  ),
                ),
              ],
            ),

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 15,
              ),

              decoration: BoxDecoration(
                color: Bkcolors.darkcardcolor,
                borderRadius:
                    BorderRadius.circular(16),
              ),

              child: loading
                  ? const Padding(
                      padding: EdgeInsets.all(16),

                      child: Center(
                        child:
                            CircularProgressIndicator(),
                      ),
                    )

                  : DropdownButtonHideUnderline(
                      child:
                          DropdownButton<
                              PaymentCategoryModel>(
                        value: selectedCategory,

                        hint: const Text(
                          'Select label',
                          style: TextStyle(
                            color: Colors.white38,
                          ),
                        ),

                        isExpanded: true,

                        dropdownColor:
                            Bkcolors.darkcardcolor,

                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white70,
                        ),

                        items:
                            categories.map((category) {
                          return DropdownMenuItem(
                            value: category,

                            child: Text(
                              category.name,
                              style:
                                  const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }).toList(),

                        onChanged: (value) {
                          setState(() {
                            selectedCategory =
                                value;
                          });
                        },
                      ),
                    ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: continuePayment,

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.deepPurpleAccent,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),

                child: const Text(
                  'Continue →',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
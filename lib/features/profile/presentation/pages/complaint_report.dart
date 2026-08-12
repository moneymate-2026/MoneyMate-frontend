import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/core/theme/theme_controller.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/controller/complaint.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComplaintReportPage extends ConsumerStatefulWidget {
  const ComplaintReportPage({super.key});

  @override
  ConsumerState<ComplaintReportPage> createState() => _ComplaintReportPageState();
}

class _ComplaintReportPageState extends ConsumerState<ComplaintReportPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() => ref.read(complaintProvider.notifier).fetchComplaints());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_titleController.text.trim().isEmpty || _descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title")),
      );
      return;
    }
    final success = await ref
        .read(complaintProvider.notifier)
        .submitComplaint(_titleController.text.trim(), _descController.text.trim());

    if (!mounted) return;
    if (success) {
      _titleController.clear();
      _descController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Complaint submit c")));
      _tabController.animateTo(1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Submitgit")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final state = ref.watch(complaintProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complaints & Reports"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: "New Complaint"), Tab(text: "My Reports")],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSubmitTab(state.isSubmitting),
          _buildReportsTab(isDark, state),
        ],
      ),
    );
  }

  Widget _buildSubmitTab(bool isSubmitting) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descController,
            maxLines: 6,
            decoration: InputDecoration(
              labelText: "Describe your issue",
              alignLabelWithHint: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isSubmitting ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            child: isSubmitting
                ? const SizedBox(
                    height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text("Submit Complaint"),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab(bool isDark, ComplaintState state) {
    if (state.isLoading) return const Center(child: CircularProgressIndicator());
    if (state.error != null) return Center(child: Text(state.error!));
    if (state.complaints.isEmpty) return const Center(child: Text("Ippol reports onnum illa"));

    return RefreshIndicator(
      onRefresh: () => ref.read(complaintProvider.notifier).fetchComplaints(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.complaints.length,
        itemBuilder: (context, index) => _buildReportCard(state.complaints[index], isDark),
      ),
    );
  }

  Widget _buildReportCard(complaint, bool isDark) {
    Color statusColor = complaint.status == "Resolved"
        ? Colors.green
        : complaint.status == "Rejected"
            ? Colors.red
            : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Bkcolors.darkcardcolor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Bkcolors.darkbordercolor : Bkcolors.lightbordercolor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(complaint.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Text(complaint.status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(complaint.description, style: const TextStyle(fontSize: 13)),
          if (complaint.adminResponse != null && complaint.adminResponse!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? Colors.blueGrey.withOpacity(0.2) : Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Admin Response:", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(complaint.adminResponse!, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
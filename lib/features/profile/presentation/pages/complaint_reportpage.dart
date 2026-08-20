import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/complaint_page.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/report_page.dart';

class ComplaintReportPage extends StatefulWidget {
  const ComplaintReportPage({super.key});

  @override
  State<ComplaintReportPage> createState() => _ComplaintReportPageState();
}

class _ComplaintReportPageState extends State<ComplaintReportPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complaints & Reports"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: "Complaint"), Tab(text: "Report")],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [ComplaintPage(), ReportPage()],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:justspeak_desktop/models/payment.dart';
import 'package:justspeak_desktop/providers/payment_provider.dart';
import 'package:provider/provider.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  int currentPage = 0;
  int totalPages = 1;

  List<Payment>? payments = [];
  dynamic filter = {};
  String? selectedStatus;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPayments();
  }

  void fetchPayments() async {
    final paymentProvider = Provider.of<PaymentProvider>(
      context,
      listen: false,
    );
    var response = await paymentProvider.get(filter: filter);

    setState(() {
      payments = response.items;
      totalPages = (response.items != null && response.items!.isNotEmpty)
          ? (response.totalCount! / 10).ceil()
          : 1;
    });
  }

  void changePage(int page) {
    if (page >= 0 && page <= totalPages) {
      setState(() {
        currentPage = page;
        filter['page'] = currentPage;
      });
      fetchPayments();
    }
  }

  void onSearchChanged(String value) {
    setState(() {
      filter['search'] = value;
      currentPage = 1;
    });
    fetchPayments();
  }

  void onStatusChanged(String? status) {
    setState(() {
      selectedStatus = status;
      if (status != null && status.isNotEmpty) {
        filter['status'] = status;
      } else {
        filter.remove('status');
      }
      currentPage = 1;
    });
    fetchPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade600,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Filteri
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dropdown za status
                  DropdownButton<String>(
                    hint: const Text("Select Status"),
                    value: selectedStatus,
                    items: ["Pending", "Completed", "Failed"]
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(),
                    onChanged: onStatusChanged,
                  ),

                  // Search
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: _searchController,
                      onChanged: onSearchChanged,
                      decoration: InputDecoration(
                        hintText: "Search payments...",
                        suffixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Tabela payments
              Expanded(
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      Colors.purple.shade100,
                    ),
                    columns: const [
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("SENDER")),
                      DataColumn(label: Text("RECIPIENT")),
                      DataColumn(label: Text("AMOUNT")),
                      DataColumn(label: Text("CREATED AT")),
                      DataColumn(label: Text("STATUS")),
                    ],
                    rows: payments!.map((p) {
                      return DataRow(
                        cells: [
                          DataCell(Text(p.id.toString())),
                          DataCell(Text(p.sender ?? "-")),
                          DataCell(Text(p.recipient ?? "-")),
                          DataCell(Text(p.amount.toStringAsFixed(2))),
                          DataCell(Text(p.createdAt.toString())),
                          DataCell(Text(p.status ?? "-")),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Paginacija
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: currentPage > 0
                        ? () => changePage(currentPage - 1)
                        : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text("Page ${currentPage + 1} of $totalPages"),
                  IconButton(
                    onPressed: currentPage + 1 < totalPages
                        ? () => changePage(currentPage + 1)
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

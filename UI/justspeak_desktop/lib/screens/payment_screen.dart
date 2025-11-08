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
  int currentPage = 1; // UI 1-based
  int itemsPerPage = 10;
  int totalPages = 1;
  int totalPaymentsCount = 0;
  List<Payment>? payments = [];
  dynamic filter = {};

  String? selectedStatus = "All";
  final TextEditingController _searchController = TextEditingController();

  static const List<String> statusOptions = [
    "All",
    "Pending",
    "Completed",
    "Failed",
  ];

  @override
  void initState() {
    super.initState();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    // To match @users_screen.dart paging: backend expects 0-based "page" and "pageSize"
    filter['page'] = currentPage - 1;
    filter['pageSize'] = itemsPerPage;

    final paymentProvider = Provider.of<PaymentProvider>(
      context,
      listen: false,
    );
    var response = await paymentProvider.get(filter: filter);

    setState(() {
      payments = response.items;
      totalPaymentsCount = response.totalCount ?? payments?.length ?? 0;
      totalPages = ((response.totalCount ?? 0) / itemsPerPage).ceil();
      if (totalPages == 0) {
        totalPages = 1;
      }
    });
  }

  void changePage(int page) {
    // page is 0-based in backend, UI uses 1-based (show page+1)
    if (page >= 0 && page < totalPages) {
      setState(() {
        currentPage = page + 1;
      });
      fetchPayments();
    }
  }

  void _onSearch() {
    setState(() {
      filter['FTS'] = _searchController.text.trim().isNotEmpty
          ? _searchController.text.trim()
          : null;
      currentPage = 1;
    });
    fetchPayments();
  }

  void onStatusChanged(String? status) {
    setState(() {
      selectedStatus = status ?? "All";
      if (status != null && status != "All") {
        filter['status'] = status;
      } else {
        filter.remove('status');
      }
      currentPage = 1;
    });
    fetchPayments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool noPayments = payments == null || payments!.isEmpty;
    final Size screenSize = MediaQuery.of(context).size;
    final double containerWidth = screenSize.width * 0.85;
    final double containerHeight = screenSize.height * 0.85;

    // For table scroll: take most of the content height
    final double filterHeight = 64;
    final double spacing = 20 + 20;
    final double paginationHeight = 56;
    final double tableHeight =
        containerHeight - (filterHeight + spacing + paginationHeight);

    return Scaffold(
      backgroundColor: Colors.purple.shade600,
      body: Center(
        child: Container(
          width: containerWidth,
          height: containerHeight,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Filters
              SizedBox(
                height: filterHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: selectedStatus,
                      items: statusOptions
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(
                                status == "All" ? "All Statuses" : status,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: onStatusChanged,
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search payments...",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: _onSearch,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onSubmitted: (_) => _onSearch(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Show total payments count above the table like in users_screen
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Text(
                  "Total payments: $totalPaymentsCount",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Table (with scroll)
              Expanded(
                child: noPayments
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Text(
                            "No payments found",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      )
                    : Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: containerWidth * 0.95,
                              ),
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
                                rows: (payments ?? [])
                                    .map(
                                      (p) => DataRow(
                                        cells: [
                                          DataCell(Text(p.id.toString())),
                                          DataCell(
                                            Text(
                                              p.sender.isNotEmpty
                                                  ? p.sender
                                                  : "-",
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              p.recipient.isNotEmpty
                                                  ? p.recipient
                                                  : "-",
                                            ),
                                          ),
                                          DataCell(
                                            Text(p.amount.toStringAsFixed(2)),
                                          ),
                                          DataCell(
                                            Text(
                                              p.createdAt
                                                  .toString()
                                                  .replaceFirst('T', ' ')
                                                  .split('.')
                                                  .first,
                                            ),
                                          ),
                                          DataCell(Text(p.status)),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              // Pagination (like users_screen)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: currentPage > 1
                        ? () => changePage(currentPage - 2)
                        : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text("Page $currentPage of $totalPages"),
                  IconButton(
                    onPressed: currentPage < totalPages
                        ? () => changePage(currentPage)
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

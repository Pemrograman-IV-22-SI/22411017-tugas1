import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tugas_1_biodata/api_service/api.dart';

class TransactionUsers extends StatefulWidget {
  const TransactionUsers({super.key});
  static String routeName = '/transaction_users';

  @override
  State<TransactionUsers> createState() => _TransactionUsersState();
}

class _TransactionUsersState extends State<TransactionUsers> {
  final Dio dio = Dio();
  bool isLoading = false;
  List<dynamic> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    setState(() {
      isLoading = true;
    });

    try {
      Response response = await dio.get(getTransactionALL);

      if (response.statusCode == 200) {
        setState(() {
          transactions = response.data['data'];
        });
      } else {
        _showError("Gagal memuat data transaksi.");
      }
    } catch (e) {
      _showError("Terjadi kesalahan saat mengambil data transaksi.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          "Semua Transaksi",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : transactions.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada transaksi.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      String formattedDate = transaction['date'].split('T')[0];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                "Judul Movie: ${transaction['movie']['title']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Tanggal: $formattedDate"),
                                  Text("Harga: Rp. ${transaction['price']}"),
                                  Text("Jumlah: ${transaction['amount']}"),
                                  Text(
                                      "Total Harga: Rp. ${transaction['total']}"),
                                ],
                              ),
                              trailing: Icon(
                                transaction['status'] == 2
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: transaction['status'] == 2
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

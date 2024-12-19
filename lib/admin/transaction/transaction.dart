import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tugas_1_biodata/api_service/api.dart';
import 'package:tugas_1_biodata/admin/home_admin.dart';
import 'package:quickalert/quickalert.dart';
import 'package:toastification/toastification.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});
  static String routeName = '/Transaction';

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
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

  Future<void> _confirmTransaction(int transactionId) async {
    try {
      setState(() {
        isLoading = true;
      });
      Response response = await dio
          .put(confirmTransaction.replaceAll(":id", transactionId.toString()));

      if (response.statusCode == 200 && response.data['status'] == true) {
        toastification.show(
          context: context,
          title: Text(response.data['msg']),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
        );
        _fetchTransactions();
      } else {
        toastification.show(
          context: context,
          title:
              Text(response.data['msg'] ?? "Gagal mengkonfirmasi transaksi."),
          type: ToastificationType.warning,
          style: ToastificationStyle.fillColored,
        );
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: const Text("Terjadi kesalahan saat mengkonfirmasi transaksi."),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showConfirmationDialog(int transactionId) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Konfirmasi',
      text: 'Konfirmasi transaksi ini?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
        _confirmTransaction(transactionId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, HomeAdmin.routeName);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.receipt_long, color: Colors.white),
              const SizedBox(width: 10),
              const Text(
                "Transaksi",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
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
                        side: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                Text(
                                  "User: ${transaction['username']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text(
                                  "${transaction['id_transaction']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  transaction['status'] == 2
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: transaction['status'] == 2
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ],
                            ),
                          ),
                          const Divider(thickness: 1, color: Colors.grey),
                          ListTile(
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Judul Movie: ${transaction['movie']['title']}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "Tanggal: $formattedDate",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Harga: Rp. ${transaction['price']}"),
                                    const SizedBox(width: 8),
                                    const Text("-"),
                                    const SizedBox(width: 8),
                                    Text("Jumlah: ${transaction['amount']}"),
                                    const SizedBox(width: 8),
                                    const Text("-"),
                                    const SizedBox(width: 8),
                                    Text(
                                        "Total Harga: Rp. ${transaction['total']}"),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton(
                                    onPressed: transaction['status'] == 1
                                        ? () => _showConfirmationDialog(
                                            transaction['id_transaction'])
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Confirm'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ));
  }
}

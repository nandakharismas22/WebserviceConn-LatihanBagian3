import 'package:flutter/material.dart'; // Mengimpor pustaka flutter material untuk pembuatan UI
import 'package:http/http.dart'
    as http; // Mengimpor pustaka http dari package http
import 'dart:convert'; // Mengimpor pustaka dart:convert untuk encoding dan decoding JSON

void main() {
  runApp(const MyApp()); // Menjalankan aplikasi Flutter
}

// Kelas untuk menampung data hasil pemanggilan API
class Activity {
  String aktivitas; // Variabel untuk menampung aktivitas
  String jenis; // Variabel untuk menampung jenis aktivitas

  Activity(
      {required this.aktivitas,
      required this.jenis}); // Constructor kelas Activity

  // Method untuk membuat objek Activity dari JSON
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'], // Mengambil data aktivitas dari JSON
      jenis: json['type'], // Mengambil data jenis aktivitas dari JSON
    );
  }
}

// Kelas MyApp yang merupakan stateful widget
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Mengembalikan objek MyAppState
  }
}

// Kelas MyAppState yang merupakan state dari MyApp
class MyAppState extends State<MyApp> {
  late Future<Activity>
      futureActivity; // Variabel untuk menampung hasil pemanggilan API
  String url = "https://www.boredapi.com/api/activity"; // URL endpoint API

  // Method untuk inisialisasi futureActivity
  Future<Activity> init() async {
    return Activity(
        aktivitas: "", jenis: ""); // Mengembalikan objek Activity kosong
  }

  // Method untuk melakukan pemanggilan API
  Future<Activity> fetchData() async {
    final response =
        await http.get(Uri.parse(url)); // Mengirim permintaan GET ke URL
    if (response.statusCode == 200) {
      // Jika server merespons dengan status code 200 OK
      // Parsing data JSON dan mengembalikan objek Activity
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // Jika terjadi kesalahan dalam pemanggilan API
      // Melempar exception dengan pesan "Gagal load"
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity = init(); // Memanggil method init() saat initState dipanggil
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      futureActivity =
                          fetchData(); // Memperbarui futureActivity dengan hasil pemanggilan API terbaru
                    });
                  },
                  child: Text("Saya bosan ..."), // Teks tombol
                ),
              ),
              // Widget FutureBuilder untuk menampilkan hasil pemanggilan API
              FutureBuilder<Activity>(
                future: futureActivity,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Jika snapshot memiliki data
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(snapshot.data!.aktivitas), // Teks aktivitas
                          Text(
                              "Jenis: ${snapshot.data!.jenis}") // Teks jenis aktivitas
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    // Jika terjadi kesalahan dalam pemanggilan API
                    return Text('${snapshot.error}'); // Teks pesan kesalahan
                  }
                  // Default: menampilkan indikator loading
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

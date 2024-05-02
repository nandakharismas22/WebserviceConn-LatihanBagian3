import 'package:flutter/material.dart'; // Mengimpor pustaka flutter material untuk pembuatan UI
import 'dart:convert'; // Mengimpor pustaka dart:convert untuk encoding dan decoding JSON
import 'package:http/http.dart'
    as http; // Mengimpor pustaka http dari package http

// Model untuk menyimpan data universitas
class University {
  final String name; // Nama universitas
  final String? stateProvince; // Provinsi (opsional)
  final List<String> domains; // Daftar domain universitas
  final List<String> webPages; // Daftar halaman web universitas
  final String alphaTwoCode; // Kode alpha dua huruf
  final String country; // Nama negara

  University({
    required this.name,
    this.stateProvince,
    required this.domains,
    required this.webPages,
    required this.alphaTwoCode,
    required this.country,
  });

  // Method untuk membuat objek University dari JSON
  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'], // Mengambil nama universitas dari JSON
      stateProvince:
          json['state-province'], // Mengambil provinsi (jika ada) dari JSON
      domains: List<String>.from(
          json['domains']), // Mengambil domain universitas dari JSON
      webPages: List<String>.from(
          json['web_pages']), // Mengambil halaman web universitas dari JSON
      alphaTwoCode:
          json['alpha_two_code'], // Mengambil kode alpha dua huruf dari JSON
      country: json['country'], // Mengambil nama negara dari JSON
    );
  }
}

// Method untuk melakukan pemanggilan API untuk mendapatkan daftar universitas Indonesia
Future<List<University>> fetchUniversities() async {
  final response = await http.get(Uri.parse(
      'http://universities.hipolabs.com/search?country=Indonesia')); // Memanggil API untuk mendapatkan daftar universitas Indonesia

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body); // Parsing data JSON
    return data
        .map((json) => University.fromJson(json))
        .toList(); // Mengembalikan daftar universitas berdasarkan data JSON
  } else {
    throw Exception(
        'Gagal memuat data universitas'); // Melemparkan exception jika gagal memuat data universitas
  }
}

void main() {
  runApp(MyApp()); // Menjalankan aplikasi Flutter
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState(); // Mengembalikan objek MyAppState
}

class _MyAppState extends State<MyApp> {
  late Future<List<University>>
      futureUniversities; // Variabel untuk menampung hasil pemanggilan API

  @override
  void initState() {
    super.initState();
    futureUniversities =
        fetchUniversities(); // Memanggil method fetchUniversities saat initState dipanggil
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Universitas di Indonesia'), // Judul AppBar
        ),
        body: FutureBuilder<List<University>>(
          future:
              futureUniversities, // Menggunakan futureUniversities sebagai sumber data FutureBuilder
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Jika snapshot memiliki data
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final university = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              university.name,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: [
                                Text('Provinsi: '),
                                Text(university.stateProvince ??
                                    'Tidak ada'), // Menampilkan provinsi atau "Tidak ada" jika null
                              ],
                            ),
                            Row(
                              children: [
                                Text('Domain: '),
                                Text(university.domains.join(
                                    ', ')), // Menampilkan domain universitas
                              ],
                            ),
                            Row(
                              children: [
                                Text('Halaman Web: '),
                                Text(university.webPages.join(
                                    ', ')), // Menampilkan halaman web universitas
                              ],
                            ),
                            Row(
                              children: [
                                Text('Kode Alpha Dua Huruf: '),
                                Text(university
                                    .alphaTwoCode), // Menampilkan kode alpha dua huruf
                              ],
                            ),
                            Row(
                              children: [
                                Text('Negara: '),
                                Text(university
                                    .country), // Menampilkan nama negara
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              // Jika terjadi kesalahan dalam pemanggilan API
              return Text('${snapshot.error}'); // Menampilkan pesan kesalahan
            }
            return CircularProgressIndicator(); // Menampilkan indikator loading jika masih menunggu data
          },
        ),
      ),
    );
  }
}

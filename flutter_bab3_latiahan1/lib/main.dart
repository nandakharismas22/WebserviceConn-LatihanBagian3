import 'dart:convert'; // Mengimpor pustaka dart:convert untuk JSON decoding dan encoding

void main() {
  String jsontranskip = '''
   {
    "nama": "Nanda Kharisma Safitri",
    "nim": "22082010036",
    "jurusan": "Sistem Informasi",
    "semester": [
      {
        "semester": 1,
        "mata_kuliah": [
          {
            "nama": "Matematika Komputasi",
            "sks": 3,
            "nilai": 4.0
          },
          {
            "nama": "Pengetahuan Bisnis",
            "sks": 3,
            "nilai": 3.6
          },
          {
            "nama": "Bahasa Pemrograman",
            "sks": 3,
            "nilai": 3.6
          }
        ]
      },
      {
        "semester": 2,
        "mata_kuliah": [
          {
            "nama": "Rekayasa Perangkat Lunak",
            "sks": 3,
            "nilai": 4.0
          },
          {
            "nama": "Sistem Informasi Manajemen",
            "sks": 3,
            "nilai": 3.3
          },
          {
            "nama": "Bahasa Pemrograman 2",
            "sks": 3,
            "nilai": 2.7
          }
        ]
      }
    ]
  }
  ''';

  Map<String, dynamic> data = jsonDecode(jsontranskip); // JSON ke Map
  double totalSks = 0; // Total SKS
  double totalNilai = 0; // Total nilai
  List<dynamic> semesters = data['semester']; // Daftar semester

  for (var semester in semesters) {
    // Loop melalui setiap semester
    List<dynamic> mataKuliah =
        semester['mata_kuliah']; // Daftar mata kuliah dalam semester tertentu
    for (var matkul in mataKuliah) {
      // Loop melalui setiap mata kuliah dalam semester
      int sks = matkul['sks']; // SKS mata kuliah
      double nilai = matkul['nilai']; // Nilai mata kuliah
      totalSks += sks; // Menambahkan SKS ke total SKS
      totalNilai += sks * nilai; // Menambahkan nilai terbobot ke total nilai
    }
  }

  double ipk = totalNilai / totalSks; // Menghitung IPK
  print('IPK: ${ipk.toStringAsFixed(2)}'); // Mencetak IPK dengan 2 desimal
}

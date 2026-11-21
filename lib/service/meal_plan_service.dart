import 'package:flutter/foundation.dart';

const List<String> _dayNames = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

const List<String> _monthNames = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

/// Buang bagian jam, sisakan tanggalnya saja.
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Contoh: "Hari ini - Sabtu, 14 November", "Besok - Minggu, 15 November",
/// atau "Senin, 16 November".
String formatMealDate(DateTime d) {
  final diff = dateOnly(d).difference(dateOnly(DateTime.now())).inDays;
  final base = '${_dayNames[d.weekday - 1]}, ${d.day} ${_monthNames[d.month - 1]}';
  if (diff == 0) return 'Hari ini - $base';
  if (diff == 1) return 'Besok - $base';
  return base;
}

/// Label singkat untuk chip pemilih hari: "Hari ini", "Besok", "Sen 16".
String shortMealDate(DateTime d) {
  final diff = dateOnly(d).difference(dateOnly(DateTime.now())).inDays;
  if (diff == 0) return 'Hari ini';
  if (diff == 1) return 'Besok';
  return '${_dayNames[d.weekday - 1].substring(0, 3)} ${d.day}';
}

/// Satu item di Meal Plan: resep + hari + waktu makan.
class MealPlanEntry {
  final String id;
  final Map<String, dynamic> recipe;
  final DateTime date;
  final String mealType;

  const MealPlanEntry({
    required this.id,
    required this.recipe,
    required this.date,
    required this.mealType,
  });

  String get recipeName => recipe['name'] as String? ?? '';
}

/// Menyimpan daftar Meal Plan selama aplikasi berjalan.
///
/// CATATAN: data hanya disimpan di memori, jadi hilang saat aplikasi
/// ditutup. Kalau nanti sudah ada database (misalnya Supabase), cukup ubah
/// isi add() dan remove() di sini. Halaman lain tidak perlu diubah.
class MealPlanService extends ChangeNotifier {
  MealPlanService._();
  static final MealPlanService instance = MealPlanService._();

  static const List<String> mealTypes = [
    'Sarapan',
    'Makan siang',
    'Makan malam',
  ];

  final List<MealPlanEntry> _entries = [];
  int _counter = 0;

  /// Daftar terurut: berdasarkan tanggal, lalu waktu makan.
  List<MealPlanEntry> get entries {
    final sorted = List<MealPlanEntry>.from(_entries);
    sorted.sort((a, b) {
      final byDate = a.date.compareTo(b.date);
      if (byDate != 0) return byDate;
      return mealTypes
          .indexOf(a.mealType)
          .compareTo(mealTypes.indexOf(b.mealType));
    });
    return sorted;
  }

  int get count => _entries.length;

  /// Mengembalikan false kalau resep yang sama sudah ada di hari dan
  /// waktu makan yang sama.
  bool add({
    required Map<String, dynamic> recipe,
    required DateTime date,
    required String mealType,
  }) {
    final day = dateOnly(date);
    final name = recipe['name'];

    final exists = _entries.any(
          (e) => e.recipeName == name && e.date == day && e.mealType == mealType,
    );
    if (exists) return false;

    _counter++;
    _entries.add(
      MealPlanEntry(
        id: '${DateTime.now().microsecondsSinceEpoch}_$_counter',
        recipe: recipe,
        date: day,
        mealType: mealType,
      ),
    );
    notifyListeners();
    return true;
  }

  void remove(String id) {
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/l10n/app_localizations.dart';
import 'package:drift/drift.dart' as drift;
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class ExportService {
  /// تصدير تقرير المبيعات إلى CSV
  static Future<void> exportSalesToCSV(
    BuildContext context,
    List<Map<String, dynamic>> salesData,
  ) async {
    try {
      final l10n = AppLocalizations.of(context)!;
      
      // تحويل البيانات إلى CSV
      List<List<dynamic>> rows = [
        ['التاريخ', 'رقم الفاتورة', 'المنتج', 'الكمية', 'السعر', 'الإجمالي', 'العميل']
      ];
      
      for (var sale in salesData) {
        rows.add([
          sale['date'] ?? '',
          sale['invoiceNumber'] ?? '',
          sale['product'] ?? '',
          sale['quantity'] ?? 0,
          sale['price'] ?? 0,
          sale['total'] ?? 0,
          sale['customer'] ?? '',
        ]);
      }
      
      String csvData = const ListToCsvConverter().convert(rows);
      
      // حفظ ومشاركة الملف
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'sales_report_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = await directory.childFile(fileName).writeAsString(csvData);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: l10n.viewReports,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم التصدير بنجاح: $fileName')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل التصدير: $e')),
      );
    }
  }
  
  /// تصدير تقرير المبيعات إلى Excel
  static Future<void> exportSalesToExcel(
    BuildContext context,
    List<Map<String, dynamic>> salesData,
  ) async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['المبيعات'];
      
      // إضافة العناوين
      sheetObject.appendRow([
        TextCellValue('التاريخ'),
        TextCellValue('رقم الفاتورة'),
        TextCellValue('المنتج'),
        IntCellValue('الكمية'),
        DecimalCellValue('السعر'),
        DecimalCellValue('الإجمالي'),
        TextCellValue('العميل'),
      ]);
      
      // إضافة البيانات
      for (var sale in salesData) {
        sheetObject.appendRow([
          TextCellValue(sale['date'] ?? ''),
          TextCellValue(sale['invoiceNumber'] ?? ''),
          TextCellValue(sale['product'] ?? ''),
          IntCellValue((sale['quantity'] ?? 0).toInt()),
          DecimalCellValue(sale['price'] ?? 0),
          DecimalCellValue(sale['total'] ?? 0),
          TextCellValue(sale['customer'] ?? ''),
        ]);
      }
      
      // حفظ الملف
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'sales_report_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final file = await directory.childFile(fileName);
      await file.writeAsBytes(excel.encode()!);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'تقرير المبيعات',
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم التصدير بنجاح: $fileName')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل التصدير: $e')),
      );
    }
  }
  
  /// تصدير قائمة عامة إلى CSV
  static Future<void> exportListToCSV<T>(
    BuildContext context,
    List<T> items,
    Map<String, String Function(T)> columns,
    String fileName,
  ) async {
    try {
      List<List<dynamic>> rows = [columns.keys.toList()];
      
      for (var item in items) {
        List<dynamic> row = columns.values.map((fn) => fn(item)).toList();
        rows.add(row);
      }
      
      String csvData = const ListToCsvConverter().convert(rows);
      final directory = await getApplicationDocumentsDirectory();
      final file = await directory.childFile('$fileName.csv').writeAsString(csvData);
      
      await Share.shareXFiles([XFile(file.path)]);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم التصدير بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل التصدير: $e')),
      );
    }
  }
}

// دوال مساعدة لاستخدامها في الصفحات
mixin ExportMixin<T extends State> on State<T> {
  void showExportDialog(List<Map<String, dynamic>> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تصدير التقرير'),
        content: const Text('اختر صيغة التصدير'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ExportService.exportSalesToCSV(context, data);
            },
            child: const Text('CSV'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ExportService.exportSalesToExcel(context, data);
            },
            child: const Text('Excel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }
}

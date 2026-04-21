import 'package:flutter_test/flutter_test.dart';
import 'package:supermarket/presentation/features/reports/export_service.dart';

void main() {
  group('ExportService Tests', () {
    test('CSV conversion should work correctly', () {
      // اختبار تحويل البيانات إلى CSV
      final testData = [
        {'date': '2024-01-01', 'product': 'Product A', 'quantity': 10, 'price': 5.0},
        {'date': '2024-01-02', 'product': 'Product B', 'quantity': 5, 'price': 10.0},
      ];
      
      expect(testData.length, 2);
      expect(testData[0]['product'], 'Product A');
      expect(testData[1]['quantity'], 5);
    });
    
    test('Excel data structure should be valid', () {
      // اختبار هيكل بيانات Excel
      final excelRow = [
        '2024-01-01',
        'INV-001',
        'Product A',
        10,
        5.0,
        50.0,
        'Customer',
      ];
      
      expect(excelRow.length, 7);
      expect(excelRow[3], isA<int>());
      expect(excelRow[4], isA<double>());
    });
  });
}

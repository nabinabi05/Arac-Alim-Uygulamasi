import 'package:flutter/material.dart';

/// Otomobil listesinde marka ve fiyat aralığı filtresi sunan alt-sayfa.
/// `Navigator.pop(context, Map<String, dynamic>)` ile seçilen filtreler döner.
class FilterSheet extends StatefulWidget {
  const FilterSheet({Key? key}) : super(key: key);

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  String _brand = '';
  RangeValues _price = const RangeValues(0, 500000);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Marka'),
            onChanged: (v) => _brand = v,
          ),
          const SizedBox(height: 16),
          Text('Fiyat Aralığı (₺): ${_price.start.toInt()} - ${_price.end.toInt()}'),
          RangeSlider(
            min: 0,
            max: 1000000,
            divisions: 100,
            labels: RangeLabels(
                _price.start.toInt().toString(),
                _price.end.toInt().toString(),
            ),
            values: _price,
            onChanged: (v) => setState(() => _price = v),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, {
              'brand': _brand,
              'priceStart': _price.start,
              'priceEnd': _price.end,
            }),
            child: const Text('Uygula'),
          ),
        ],
      ),
    );
  }
}

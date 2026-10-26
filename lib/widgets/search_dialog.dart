import 'package:flutter/material.dart';

import '../constants.dart';

/// مربع بحث تفاعلي يعرض كل منتجات EVO مع إمكانية الفلترة السريعة والانتقال المباشر للـ 3D
class ProductSearchDialog extends StatefulWidget {
  final void Function(String productTitle) onSelectProduct;

  const ProductSearchDialog({super.key, required this.onSelectProduct});

  static Future<void> show(BuildContext context, void Function(String) onSelect) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => ProductSearchDialog(onSelectProduct: onSelect),
    );
  }

  @override
  State<ProductSearchDialog> createState() => _ProductSearchDialogState();
}

class _ProductSearchDialogState extends State<ProductSearchDialog> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  String _selectedCategory = 'All';

  final List<({String name, String spec, String type, bool has3D})> _allItems = [
    // الأجهزة الطبية الذكية
    (name: 'EVO PLUS', spec: 'Blood Glucose Monitoring System • جهاز قياس السكر ثلاثي الأبعاد', type: 'Devices', has3D: true),
    (name: 'EVO STAR', spec: 'Blood Hemoglobin Measuring System • جهاز قياس الهيموجلوبين', type: 'Devices', has3D: true),
    // كواشف التحاليل السريعة (Rapid Test Kits)
    (name: 'H. Pylori Ag TEST', spec: '25 / TEST - 18 BAG - 450 CARTON • علبة تفاعلية 3D', type: 'Rapid Tests', has3D: true),
    (name: 'CTNI TEST', spec: '40 / TEST - 16 BAG - 640 CARTON', type: 'Rapid Tests', has3D: true),
    (name: 'HCG TEST', spec: '40 / TEST - 16 BAG - 640 CARTON', type: 'Rapid Tests', has3D: true),
    (name: 'HBs Ag TEST', spec: '40 / TEST - 16 BAG - 640 CARTON', type: 'Rapid Tests', has3D: true),
    (name: 'FOB TEST', spec: '40 / TEST - 16 BAG - 640 CARTON', type: 'Rapid Tests', has3D: true),
    (name: 'HIV TEST', spec: '40 / TEST - 16 BAG - 640 CARTON', type: 'Rapid Tests', has3D: true),
    (name: 'Multi DRUGS TEST', spec: '40 / TEST - 16 BAG - 640 CARTON', type: 'Rapid Tests', has3D: true),
    (name: 'HAV IgG / IgM TEST', spec: '25 / TEST - 18 BAG - 450 CARTON', type: 'Rapid Tests', has3D: true),
    (name: 'H. Pylori Ab TEST', spec: '40 / TEST - 16 BAG - 640 CARTON', type: 'Rapid Tests', has3D: true),
    (name: 'HCV TEST', spec: '40 / TEST - 16 BAG - 640 CARTON', type: 'Rapid Tests', has3D: true),
  ];

  List<({String name, String spec, String type, bool has3D})> get _filtered {
    return _allItems.where((item) {
      final matchesQuery = _query.isEmpty ||
          item.name.toLowerCase().contains(_query.toLowerCase()) ||
          item.spec.toLowerCase().contains(_query.toLowerCase());
      final matchesCat = _selectedCategory == 'All' || item.type == _selectedCategory;
      return matchesQuery && matchesCat;
    }).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 700;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: mobile ? double.infinity : 640,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          constraints: const BoxConstraints(maxHeight: 620),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. رأس البحث وحقل الكتابة
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: kBlueGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.search, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: 'ابحث باسم المنتج (مثلاً: EVO PLUS, H. Pylori, CTNI)...',
                          hintStyle: TextStyle(color: Colors.black38, fontSize: mobile ? 13 : 15),
                          border: InputBorder.none,
                        ),
                        onChanged: (v) => setState(() => _query = v.trim()),
                      ),
                    ),
                    if (_controller.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.black45),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),

              // 2. تصنيفات التصفية السريعة
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    _catChip('All', 'الكل'),
                    const SizedBox(width: 8),
                    _catChip('Devices', 'الأجهزة (3D)'),
                    const SizedBox(width: 8),
                    _catChip('Rapid Tests', 'كواشف التحاليل'),
                  ],
                ),
              ),

              // 3. قائمة المنتجات
              Flexible(
                child: _filtered.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(40),
                        child: Text(
                          'لا يوجد منتج مطابق لبحثك',
                          style: TextStyle(color: Colors.black45, fontSize: 14),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        itemCount: _filtered.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 6),
                        itemBuilder: (context, i) {
                          final item = _filtered[i];
                          return InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.pop(context);
                              widget.onSelectProduct(item.name);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFE5E7EB)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: item.type == 'Devices'
                                          ? const Color(0xFFFFEEEE)
                                          : const Color(0xFFEAF2FF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      item.type == 'Devices'
                                          ? Icons.medical_services_rounded
                                          : Icons.science_rounded,
                                      color: item.type == 'Devices'
                                          ? const Color(0xFFCF1F2A)
                                          : kBlue,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              item.name,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF111827),
                                              ),
                                            ),
                                            if (item.has3D) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  gradient: kBlueGradient,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: const Text(
                                                  '3D SIMULATOR',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9.5,
                                                    fontWeight: FontWeight.w800,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          item.spec,
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            color: Color(0xFF6B7280),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios_rounded,
                                      size: 15, color: Colors.black38),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // 4. فوتر معلومات سريعة
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_filtered.length} منتجات متاحة',
                      style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600),
                    ),
                    const Text(
                      'اضغط على أي منتج لفتحه وعرضه',
                      style: TextStyle(fontSize: 11.5, color: Colors.black45),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _catChip(String catKey, String label) {
    final active = _selectedCategory == catKey;
    return InkWell(
      onTap: () => setState(() => _selectedCategory = catKey),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? kBlue : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: active ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

const kBlue = Color(0xFF0055D0);
const kLightBlue = Color(0xFF4A98FF);
const kNavy = Color(0xFF2535A8);
const kGrey = Color(0xFFF4F4F4);

const kBlueGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [kBlue, kLightBlue],
);

enum AppPage { products, contact, about, related }

class Product {
  final String name, spec, image, model; // model = مسار ملف الـ 3D (.glb)
  const Product(this.name, this.spec, this.image, this.model);
}

/// الأجهزة (EVO STAR / EVO PLUS) وموديلاتها
class Device3D {
  final String name, subtitle, model;
  const Device3D(this.name, this.subtitle, this.model);
}

const devices = [
  Device3D('EVO STAR', 'Blood Hemoglobin Measuring System', 'assets/models/evo_star.glb'),
  Device3D('EVO PLUS', 'Blood Glucose Monitoring System', 'assets/models/evo_plus.glb'),
];

const products = [
  Product('CTNI TEST', '40 / TEST - 16 BAG - 640 CARTON', 'assets/images/ctni_orange.png', 'assets/models/ctni.glb'),
  Product('HCG TEST', '40 / TEST - 16 BAG - 640 CARTON', 'assets/images/hcg.png', 'assets/models/hcg.glb'),
  Product('HBs Ag TEST', '40 / TEST - 16 BAG - 640 CARTON', 'assets/images/hbsag.png', 'assets/models/hbsag.glb'),
  Product('FOB TEST', '40 / TEST - 16 BAG - 640 CARTON', 'assets/images/fob.png', 'assets/models/fob.glb'),
  Product('HIV TEST', '40 / TEST - 16 BAG - 640 CARTON', 'assets/images/hiv.png', 'assets/models/hiv.glb'),
  Product('H. Pylori Ag TEST', '25 / TEST - 18 BAG - 450 CARTON', 'assets/images/hpylori_ag.png', 'assets/models/hpylori_ag.glb'),
  Product('Multi DRUGS TEST', '40 / TEST - 16 BAG - 640 CARTON', 'assets/images/multi_drugs.png', 'assets/models/multi_drugs.glb'),
  Product('HAV IgG / IgM TEST', '25 / TEST - 18 BAG - 450 CARTON', 'assets/images/hav.png', 'assets/models/hav.glb'),
  Product('H. Pylori Ab TEST', '40 / TEST - 16 BAG - 640 CARTON', 'assets/images/hpylori_ab.png', 'assets/models/hpylori_ab.glb'),
  Product('HCV TEST', '40 / TEST - 16 BAG - 640 CARTON', 'assets/images/hcv.png', 'assets/models/hcv.glb'),
];

/// المنتجات اللي ليها علبة 3D تفتح (الاسم -> id)
const box3dIds = {
  'H. Pylori Ag TEST': 'hpylori_ag',
  'CTNI TEST': 'ctni',
  'EVO PLUS': 'evo_plus',
};

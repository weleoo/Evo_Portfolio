# 🏥 EVO MED — Interactive Medical Equipment & IVD Portfolio

<p align="center">
  <img src="https://evomed.web.app/icons/Icon-192.png" alt="EVO MED Logo" width="100" />
</p>

<p align="center">
  <b>Advanced Medical Diagnostics & Laboratory Devices Showcase Platform</b><br>
  Built with <b>Flutter Web & Mobile</b>, featuring real-time 3D device simulation, interactive showroom hotspots, and live analog clock mechanics.
</p>

<p align="center">
  <a href="https://evomed.web.app"><img src="https://img.shields.io/badge/Live_Demo-evomed.web.app-0055D0?style=for-the-badge&logo=google-chrome&logoColor=white" alt="Live Demo"></a>
  <a href="https://firebase.google.com"><img src="https://img.shields.io/badge/Firebase_Hosting-Active-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase Hosting"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"></a>
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="MIT License">
</p>

---

## 🌐 Live URLs

| Platform | Deployment URL | Status |
| :--- | :--- | :--- |
| **Primary Domain** | [**https://evomed.web.app**](https://evomed.web.app) | 🟢 Live & Operational |
| **Mirror Domain** | [**https://evo-portfolio.web.app**](https://evo-portfolio.web.app) | 🟢 Live & Operational |

---

## 📸 Key Features & Technical Highlights

### 🌟 1. Interactive 3D Medical Showroom
* **Exploration Hub:** A photorealistic clinical showroom hero banner with calibrated hotspot zones that smoothly route users to detailed 3D inspections and product categories.
* **3D Device Simulation:** High-fidelity 3D inspection for the flagship **EVO STAR** and **EVO PLUS** meters, featuring full 360° orbital rotation, zoom, packaging animations, and device bay views powered by Three.js & WebGL.

### 🕒 2. Precision Swiss-Style Live Wall Clock
* **Real-time Analog Engine:** Custom-drawn with Flutter’s `CustomPainter` without any static image overlays.
* **Micro-Smooth Movement:** 50ms periodic timer calculates exact trigonometric second, minute, and hour hand angles ($millis \times 2\pi / 60$).
* **Brand Aesthetics:** Metallic gradient bezel, precision tick marks, and an auto-scaling EVO MED insignia with hardware-accelerated clipping (`clipPath`) ensuring zero artifact bleed across any viewport.

### 📱 3. Adaptive Mobile & Desktop Layout (60–120 FPS)
* Fully responsive interface optimized for desktop ultra-wides, laptops, tablets, and smartphones.
* Adaptive product card layouts, intelligent touch targets, and hardware-accelerated transitions.

### 🔬 4. Comprehensive In-Vitro Diagnostics (IVD) Catalog
* **Rapid Diagnostic Tests:** Detailed cards and specifications for **H. pylori Antigen**, **Cardiac Troponin I (cTnI)**, **HCG Pregnancy**, infectious disease panels, and multi-drug tests.
* **Clinical Specs:** Immediate access to sample requirements, sensitivity, specificity, reading times, and storage conditions.

### 🚀 5. Production PWA & SEO Ready
* **Schema.org Structured Data:** Validated `MedicalOrganization` JSON-LD metadata for Google Search.
* **Full Meta Stack:** OpenGraph and Twitter Card tags for rich social previews.
* **Search Console Verified:** HTML verification token integrated directly into root build.
* **Multi-resolution Favicons:** Square asset suite from 48px to 512px matching modern search engine standards.

---

## 🏗️ Architecture & Tech Stack

```
Evo_Portfolio/
├── lib/
│   ├── main.dart                  # Application entry point & theme setup
│   ├── app_shell.dart             # Main showroom layout, adaptive headers & navigation
│   ├── constants.dart             # Palette (kBlue, kNavy), typography & theme tokens
│   ├── logo_data.dart             # Vector assets, base64 data & brand graphics
│   ├── models/
│   │   └── product.dart           # IVD product models & catalog definitions
│   ├── pages/
│   │   ├── splash_screen.dart     # ECG pulse intro animation & quick-skip routing
│   │   ├── products_page.dart     # Categorized diagnostic kit & device gallery
│   │   ├── about_page.dart        # Corporate vision, certifications & milestones
│   │   └── contact_page.dart      # Direct inquiry forms & communication channels
│   └── widgets/
│       ├── live_clock.dart        # Real-time mathematical analog wall clock
│       ├── evo_box_3d.dart        # 3D device & package interactive inspection
│       ├── product_card.dart      # Micro-animated clinical diagnostic cards
│       └── app_header.dart        # Sticky navigation bar with search & quick actions
├── assets/
│   ├── 3d/                        # Three.js 3D viewers, controls, and canvas pipelines
│   │   └── textures/              # 4K textures for EVO PLUS, cTnI & H. pylori
│   └── images/                    # Master showroom photography & device renders
└── web/                           # PWA manifest, SEO meta tags, sitemap, icons
```

* **Framework:** [Flutter](https://flutter.dev) (Channel stable, Web & Mobile)
* **Language:** [Dart](https://dart.dev)
* **3D Engine:** Three.js / WebGL / `model_viewer_plus`
* **Cloud & CDN:** [Google Firebase Hosting](https://firebase.google.com) (HTTP/2, SSL, Global Edge Caching)
* **Fonts:** Google Fonts (`Poppins`, `Montserrat`)

---

## 💻 Getting Started Locally

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.11.0` or newer)
* [Dart SDK](https://dart.dev/get-dart)
* Google Chrome, Microsoft Edge, or an Android/iOS emulator

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/weleoo/Evo_Portfolio.git
   cd Evo_Portfolio
   ```

2. **Install project dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run in development mode (Chrome):**
   ```bash
   flutter run -d chrome
   ```

4. **Verify code quality:**
   ```bash
   flutter analyze
   ```

---

## 📦 Building for Production

To generate the optimized web distribution:

```bash
flutter build web --release
```

The compiled release assets will be located in `build/web/`.

### Deploying to Firebase Hosting

```bash
# Login to Firebase
npx firebase-tools login

# Deploy directly to live hosting
npx firebase-tools deploy --only hosting
```

---

## 👨‍💻 Author & Maintainer

* **Waleed Adel** — [@weleoo](https://github.com/weleoo)
* Project: **EVO MED Clinical Diagnostic Portfolio**

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

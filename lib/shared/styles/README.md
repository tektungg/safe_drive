# Safe Drive Style System

Sistem style yang komprehensif untuk aplikasi Safe Drive, mencakup warna dan tipografi yang konsisten.

## 📁 File Struktur

```
lib/shared/styles/
├── color_style.dart    # Sistem warna
├── text_style.dart     # Sistem tipografi
└── README.md          # Dokumentasi ini
```

---

## 🎨 Color Style System

File: `color_style.dart`

### Kategori Warna

#### 1. Primary & Secondary Colors
```dart
ColorStyle.primary          // #007bff - Warna utama aplikasi
ColorStyle.primaryLight     // Variasi lebih terang
ColorStyle.primaryDark      // Variasi lebih gelap
ColorStyle.primaryContainer // Background untuk primary elements

ColorStyle.secondary        // #6c757d - Warna sekunder
ColorStyle.secondaryLight
ColorStyle.secondaryDark
ColorStyle.secondaryContainer
```

#### 2. Semantic Colors
```dart
// Success (Green)
ColorStyle.success          // #28a745
ColorStyle.successLight
ColorStyle.successDark
ColorStyle.successContainer

// Danger (Red)
ColorStyle.danger           // #dc3545
ColorStyle.dangerLight
ColorStyle.dangerDark
ColorStyle.dangerContainer

// Warning (Yellow/Orange)
ColorStyle.warning          // #ffc107
ColorStyle.warningLight
ColorStyle.warningDark
ColorStyle.warningContainer

// Info (Blue)
ColorStyle.info             // #17a2b8
ColorStyle.infoLight
ColorStyle.infoDark
ColorStyle.infoContainer
```

#### 3. Gray Scale
```dart
ColorStyle.gray50   // #fafafa - Paling terang
ColorStyle.gray100  // #f5f5f5
ColorStyle.gray200  // #eeeeee
ColorStyle.gray300  // #e0e0e0
ColorStyle.gray400  // #bdbdbd
ColorStyle.gray500  // #9e9e9e - Medium
ColorStyle.gray600  // #757575
ColorStyle.gray700  // #616161
ColorStyle.gray800  // #424242
ColorStyle.gray900  // #212121 - Paling gelap
```

#### 4. Text Colors
```dart
ColorStyle.textPrimary      // Teks utama
ColorStyle.textSecondary    // Teks sekunder
ColorStyle.textTertiary     // Teks tersier
ColorStyle.textDisabled     // Teks disabled
ColorStyle.textHint         // Placeholder/hint

// Text on colored backgrounds
ColorStyle.textOnPrimary    // Putih untuk background primary
ColorStyle.textOnSecondary
ColorStyle.textOnSuccess
ColorStyle.textOnDanger
ColorStyle.textOnWarning    // Hitam untuk background warning
ColorStyle.textOnInfo
ColorStyle.textOnDark
ColorStyle.textOnLight      // Hitam untuk background light
```

#### 5. Background Colors
```dart
ColorStyle.background       // #ffffff
ColorStyle.backgroundDark   // #f5f5f5
ColorStyle.backgroundGray   // #e9ecef
ColorStyle.surface          // #ffffff
ColorStyle.surfaceVariant   // #f8f9fa
ColorStyle.scaffold         // #f5f5f5
```

#### 6. Border & Divider
```dart
ColorStyle.border           // #dee2e6
ColorStyle.borderLight      // #e9ecef
ColorStyle.borderDark       // #adb5bd
ColorStyle.divider          // #e0e0e0
ColorStyle.outline          // #6c757d
```

#### 7. Shadow & Overlay
```dart
ColorStyle.shadow           // 10% black
ColorStyle.shadowLight      // 5% black
ColorStyle.shadowDark       // 20% black

ColorStyle.overlay          // 50% black
ColorStyle.overlayLight     // 30% black
ColorStyle.overlayDark      // 60% black
ColorStyle.scrim            // 40% black
```

#### 8. Interactive States
```dart
ColorStyle.hover            // 4% black
ColorStyle.pressed          // 8% black
ColorStyle.focus            // 12% black
ColorStyle.selected         // 8% primary
ColorStyle.disabled         // 38% black
```

#### 9. Link Colors
```dart
ColorStyle.link             // #007bff
ColorStyle.linkHover        // #0056b3
ColorStyle.linkVisited      // #6c757d
```

#### 10. Status Colors (Driving)
```dart
ColorStyle.safe             // #28a745 - Mengemudi aman
ColorStyle.moderate         // #ffc107 - Sedang
ColorStyle.risky            // #ff9800 - Berisiko
ColorStyle.dangerous        // #dc3545 - Berbahaya
```

#### 11. Notification
```dart
ColorStyle.notificationBadge  // #dc3545
ColorStyle.notificationDot    // #007bff
```

#### 12. Basic Colors
```dart
ColorStyle.white            // #ffffff
ColorStyle.black            // #000000
ColorStyle.transparent      // Transparan
```

### Contoh Penggunaan

```dart
// Container dengan warna primary
Container(
  color: ColorStyle.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: ColorStyle.textOnPrimary),
  ),
)

// Border
Container(
  decoration: BoxDecoration(
    border: Border.all(color: ColorStyle.border),
    borderRadius: BorderRadius.circular(8),
  ),
)

// Shadow
Container(
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: ColorStyle.shadow,
        blurRadius: 10,
      ),
    ],
  ),
)
```

---

## 📝 Text Style System

File: `text_style.dart`

### Kategori Text Styles

#### 1. Display Styles (36sp - 28sp)
Untuk teks terbesar di layar
```dart
TextStyles.displayLarge   // 36sp, ExtraBold - Splash, onboarding
TextStyles.displayMedium  // 32sp, Bold - Main titles
TextStyles.displaySmall   // 28sp, Bold - Dialog titles
```

#### 2. Headline Styles (24sp - 18sp)
Untuk header section
```dart
TextStyles.headlineLarge  // 24sp, Bold - Screen headers
TextStyles.headlineMedium // 20sp, Bold - Card headers
TextStyles.headlineSmall  // 18sp, SemiBold - Widget headers
```

#### 3. Title Styles (18sp - 14sp)
Untuk judul kartu dan teks yang ditekankan
```dart
TextStyles.titleLarge   // 18sp, SemiBold - Card titles
TextStyles.titleMedium  // 16sp, SemiBold - List item titles
TextStyles.titleSmall   // 14sp, SemiBold - Small card titles
```

#### 4. Body Styles (16sp - 12sp)
Untuk teks konten utama
```dart
TextStyles.bodyLarge   // 16sp, Regular - Main content
TextStyles.bodyMedium  // 14sp, Regular - Default body text
TextStyles.bodySmall   // 12sp, Regular - Secondary text
```

#### 5. Label Styles (14sp - 11sp)
Untuk label form dan UI
```dart
TextStyles.labelLarge   // 14sp, Medium - Form labels
TextStyles.labelMedium  // 12sp, Medium - Small labels, tags
TextStyles.labelSmall   // 11sp, Medium - Tiny labels, badges
```

#### 6. Button Styles (16sp - 12sp)
Untuk teks tombol
```dart
TextStyles.buttonLarge   // 16sp, SemiBold - Primary buttons
TextStyles.buttonMedium  // 14sp, SemiBold - Default buttons
TextStyles.buttonSmall   // 12sp, SemiBold - Small buttons
```

#### 7. Caption Styles (12sp - 10sp)
Untuk teks helper dan keterangan
```dart
TextStyles.captionLarge   // 12sp, Regular - Helper text
TextStyles.captionMedium  // 11sp, Regular - Small helper text
TextStyles.captionSmall   // 10sp, Regular - Footnotes
```

### Specialized Styles

#### Authentication
```dart
TextStyles.authTitle      // 32sp - Sign in/up headers
TextStyles.authSubtitle   // 16sp - Sign in/up subtitles
```

#### Home/Dashboard
```dart
TextStyles.greeting       // 28sp - "Hello, User!"
TextStyles.statValue      // 20sp - Dashboard numbers
TextStyles.statLabel      // 12sp - Stat descriptions
```

#### Forms
```dart
TextStyles.inputText      // 14sp - Input field text
TextStyles.inputLabel     // 14sp - Field labels
TextStyles.inputHint      // 14sp - Placeholders
TextStyles.inputError     // 12sp - Error messages
```

#### Links
```dart
TextStyles.link           // 14sp - Underlined links
TextStyles.linkPlain      // 14sp - Links without underline
```

#### Empty States
```dart
TextStyles.emptyStateTitle     // 16sp
TextStyles.emptyStateSubtitle  // 14sp
```

#### Dialogs & Sheets
```dart
TextStyles.toast                // 14sp - Toast messages
TextStyles.dialogTitle          // 20sp - Dialog headers
TextStyles.dialogMessage        // 14sp - Dialog content
TextStyles.bottomSheetTitle     // 20sp - Bottom sheet headers
TextStyles.bottomSheetSubtitle  // 14sp - Bottom sheet content
```

#### Navigation
```dart
TextStyles.appBarTitle    // 20sp - AppBar titles
TextStyles.tabLabel       // 14sp - Tab labels
```

#### Miscellaneous
```dart
TextStyles.chipLabel      // 12sp - Chips/badges
TextStyles.price          // 24sp - Monetary values
TextStyles.timestamp      // 12sp - Dates/times
```

### Status Styles
```dart
TextStyles.statusSafe         // Green - Safe driving
TextStyles.statusModerate     // Yellow - Moderate
TextStyles.statusRisky        // Orange - Risky
TextStyles.statusDangerous    // Red - Dangerous

TextStyles.statusSuccess      // Success messages
TextStyles.statusWarning      // Warnings
TextStyles.statusError        // Errors
TextStyles.statusInfo         // Info messages
```

### Contoh Penggunaan

```dart
// Judul layar
Text(
  'Welcome to Safe Drive',
  style: TextStyles.displayMedium,
)

// Konten body
Text(
  'Your driving data will be analyzed to provide safety insights.',
  style: TextStyles.bodyMedium,
)

// Label form
Text(
  'Email Address',
  style: TextStyles.inputLabel,
)

// Tombol
ElevatedButton(
  child: Text('Sign In', style: TextStyles.buttonMedium),
)

// Status
Text(
  'Driving Safely',
  style: TextStyles.statusSafe,
)

// Custom dengan copyWith
Text(
  'Custom Text',
  style: TextStyles.bodyLarge.copyWith(
    color: ColorStyle.primary,
    fontWeight: FontWeight.bold,
  ),
)
```

---

## 📐 Font Weight Reference

```dart
FontWeight.w100  // Thin
FontWeight.w200  // ExtraLight
FontWeight.w300  // Light
FontWeight.w400  // Regular/Normal
FontWeight.w500  // Medium
FontWeight.w600  // SemiBold
FontWeight.w700  // Bold
FontWeight.w800  // ExtraBold
FontWeight.w900  // Black
```

---

## 🎯 Best Practices

### 1. Consistency
Selalu gunakan ColorStyle dan TextStyles dari sistem ini, jangan hardcode warna atau style.

❌ **JANGAN:**
```dart
Text(
  'Hello',
  style: TextStyle(
    fontSize: 16,
    color: Colors.black,
  ),
)
```

✅ **LAKUKAN:**
```dart
Text(
  'Hello',
  style: TextStyles.bodyLarge,
)
```

### 2. Semantic Naming
Gunakan warna sesuai dengan tujuan semantiknya.

❌ **JANGAN:**
```dart
color: ColorStyle.danger  // untuk tombol primary
```

✅ **LAKUKAN:**
```dart
color: ColorStyle.primary  // untuk tombol primary
color: ColorStyle.danger   // untuk error/delete actions
```

### 3. Accessibility
Pastikan kontras warna memenuhi WCAG AA (4.5:1 untuk teks normal).

```dart
// Background gelap + Text terang
Container(
  color: ColorStyle.primary,
  child: Text(
    'Hello',
    style: TextStyles.bodyMedium.copyWith(
      color: ColorStyle.textOnPrimary,
    ),
  ),
)
```

### 4. Responsive
Gunakan `.sp` untuk font size (dari flutter_screenutil).

```dart
// Sudah otomatis responsive di TextStyles
Text('Hello', style: TextStyles.bodyLarge)  // ✅

// Jika custom
Text(
  'Custom',
  style: TextStyle(fontSize: 16.sp),  // ✅
)
```

### 5. Reusability
Gunakan `copyWith()` untuk modifikasi kecil.

```dart
Text(
  'Important',
  style: TextStyles.bodyMedium.copyWith(
    fontWeight: FontWeight.bold,
    color: ColorStyle.danger,
  ),
)
```

---

## 🔄 Migration Guide

Jika ada kode lama dengan hardcoded values:

### Colors
```dart
// Before
color: Colors.blue
color: Color(0xFF007bff)

// After
color: ColorStyle.primary
```

### Text Styles
```dart
// Before
style: TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: Colors.black,
)

// After
style: TextStyles.titleMedium
```

---

## 📱 Dark Mode (Future)

Untuk implementasi dark mode di masa depan:

```dart
// color_style_dark.dart
class ColorStyleDark {
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color background = Color(0xFF121212);
  // ... dst
}

// Kemudian di main.dart atau theme:
final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
final colors = isDarkMode ? ColorStyleDark : ColorStyle;
```

---

## 🛠️ Maintenance

Saat menambah warna atau text style baru:

1. Tambahkan di file yang sesuai (`color_style.dart` atau `text_style.dart`)
2. Beri dokumentasi inline yang jelas
3. Update file README.md ini
4. Gunakan naming yang konsisten dengan yang sudah ada
5. Test pada berbagai ukuran layar

---

## 📞 Support

Jika ada pertanyaan atau saran tentang style system:
- Buka issue di repository
- Contact: [Your Contact Info]

---

**Last Updated:** 2025-01-22
**Version:** 1.0.0

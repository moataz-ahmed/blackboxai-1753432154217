# Fonts Directory

This directory contains the font files referenced in `pubspec.yaml`. Currently, placeholder files are provided with download instructions.

## Required Font Files

### Cairo Font Family
- `Cairo-Regular.ttf` - Regular weight (400)
- `Cairo-Bold.ttf` - Bold weight (700)

### Noto Sans Arabic Font Family (for Kurdish support)
- `NotoSansArabic-Regular.ttf` - Regular weight (400)
- `NotoSansArabic-Bold.ttf` - Bold weight (700)

## Current Status

⚠️ **PLACEHOLDER FILES PRESENT** - The current `.placeholder` files need to be replaced with actual font files.

## Download Instructions

### Method 1: Google Fonts (Recommended)

#### Cairo Font:
1. Visit: https://fonts.google.com/specimen/Cairo
2. Click "Download family" button
3. Extract the ZIP file
4. Copy `Cairo-Regular.ttf` and `Cairo-Bold.ttf` to this directory
5. Delete the corresponding `.placeholder` files

#### Noto Sans Arabic Font:
1. Visit: https://fonts.google.com/noto/specimen/Noto+Sans+Arabic
2. Click "Download family" button
3. Extract the ZIP file
4. Copy `NotoSansArabic-Regular.ttf` and `NotoSansArabic-Bold.ttf` to this directory
5. Delete the corresponding `.placeholder` files

### Method 2: Google Webfonts Helper

#### Cairo Font:
1. Visit: https://gwfh.mranftl.com/fonts/cairo?subsets=latin
2. Select "Legacy Support" for TTF format
3. Download the font files
4. Rename and place in this directory

### Method 3: GitHub Repositories

#### Noto Sans Arabic:
1. Visit: https://github.com/notofonts/arabic
2. Navigate to the fonts folder
3. Download the required TTF files

## Font Licenses

Both font families are licensed under the **SIL Open Font License, Version 1.1**:
- Free for commercial and personal use
- Can be bundled with applications
- Can be modified and redistributed
- Full license: http://scripts.sil.org/OFL

## Installation Steps

1. **Download** the actual font files using one of the methods above
2. **Replace** the `.placeholder` files with the actual `.ttf` files
3. **Verify** the file names match exactly:
   - `Cairo-Regular.ttf`
   - `Cairo-Bold.ttf`
   - `NotoSansArabic-Regular.ttf`
   - `NotoSansArabic-Bold.ttf`
4. **Run** `flutter pub get` to refresh the asset bundle
5. **Test** the fonts in the app

## Usage in App

The fonts are configured in `pubspec.yaml` and used in the app's theme based on the selected language:

```dart
fontFamily: languageProvider.currentLanguage == 'ar' || 
           languageProvider.currentLanguage == 'ku' 
    ? 'Cairo'           // Arabic and Kurdish
    : 'Roboto',         // English (default)
```

### Font Families:
- **Cairo**: Used for Arabic and Kurdish text (RTL languages)
- **NotoKurdish**: Alternative for Kurdish text (mapped to Noto Sans Arabic)
- **Roboto**: Default system font for English text

## Troubleshooting

### Font Not Loading:
1. Check file names match exactly (case-sensitive)
2. Ensure files are actual TTF fonts, not placeholders
3. Run `flutter clean && flutter pub get`
4. Restart the app

### Missing Characters:
- Cairo font supports Arabic script
- Noto Sans Arabic has extensive Unicode coverage
- Both fonts support Kurdish characters

### Performance:
- Font files are bundled with the app
- No network requests needed at runtime
- Fonts are cached by Flutter engine

## File Structure

```
fonts/
├── README.md                           # This file
├── Cairo-Regular.ttf                   # Cairo regular weight
├── Cairo-Bold.ttf                      # Cairo bold weight
├── NotoSansArabic-Regular.ttf         # Noto Sans Arabic regular
├── NotoSansArabic-Bold.ttf            # Noto Sans Arabic bold
└── *.placeholder                       # Placeholder files (to be deleted)
```

## Next Steps

1. Download the actual font files
2. Replace placeholder files
3. Test the app with different languages
4. Verify text rendering in Arabic, Kurdish, and English

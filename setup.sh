#!/bin/bash
# GarasiIn Flutter Setup Script
# Jalankan SEKALI dari folder /home/kiki-mahesta/Documents/2026/GarasiIn

set -e

echo ""
echo "╔══════════════════════════════════════╗"
echo "║      GarasiIn - Flutter Setup        ║"
echo "╚══════════════════════════════════════╝"
echo ""

# 1. Backup files kita yang penting
echo "▶ Step 1: Backup files GarasiIn..."
cp lib/main.dart lib/main_garasin_backup.dart
cp pubspec.yaml pubspec_garasin_backup.dart

# 2. Flutter create untuk generate android/, ios/, dll.
echo "▶ Step 2: Generate scaffolding Flutter..."
flutter create . --project-name garasin --org com.garasin --platforms android,ios --overwrite

# 3. Restore files GarasiIn
echo "▶ Step 3: Restore files GarasiIn..."
cp lib/main_garasin_backup.dart lib/main.dart
rm lib/main_garasin_backup.dart
cp pubspec_garasin_backup.dart pubspec.yaml
rm pubspec_garasin_backup.dart

# 4. Install dependencies
echo "▶ Step 4: flutter pub get..."
flutter pub get

echo ""
echo "╔══════════════════════════════════════╗"
echo "║      ✅ Setup Berhasil!              ║"
echo "╠══════════════════════════════════════╣"
echo "║  flutter run                         ║"
echo "╠══════════════════════════════════════╣"
echo "║  Login Demo:                         ║"
echo "║  Pemilik: pemilik@gmail.com          ║"
echo "║  Penyewa: penyewa@gmail.com          ║"
echo "╚══════════════════════════════════════╝"
echo ""

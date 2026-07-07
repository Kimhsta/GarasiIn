# GarasiIn

**Marketplace Sewa Garasi Rumah untuk Parkir Mobil**

GarasiIn adalah aplikasi mobile marketplace yang menghubungkan pemilik garasi rumah yang tidak terpakai dengan penyewa yang membutuhkan tempat parkir mobil. Dibangun dengan Flutter + GetX + SQLite, mendukung dua peran: **Pemilik Garasi** dan **Penyewa**.

**Stack**: Flutter · Dart · GetX · SQLite · Repository Pattern · SHA-256 Password Hashing

---

## Fitur Utama

### Autentikasi
- Login dengan email & password (di-hash SHA-256)
- Register dengan pilih peran (Pemilik/Penyewa)
- Session persistence via SharedPreferences
- Validasi email format, password minimal 6 karakter
- Cek email uniqueness saat register & update profil

### Pemilik Garasi (Owner)
- **Dashboard**: statistik (total/disewa/tersedia/booking), carousel booking pending, daftar garasi
- **CRUD Garasi**: tambah/edit/hapus garasi dengan fasilitas (chip input), foto (ImagePicker)
- **Kelola Booking**: terima/tolak booking dengan transaction (update rental + garage status)
- **Riwayat Penyewaan**: daftar semua rental dengan status
- **Profil**: edit profil, ubah password, logout

### Penyewa (Renter)
- **Home**: hero banner, 4 kategori (Terdekat/Populer/Murah/Premium), carousel unggulan, daftar terbaru
- **Pencarian**: search by nama/alamat/kota + filter harga (3 range)
- **Detail Garasi**: gambar, dimensi, akses jalan, deskripsi, fasilitas
- **Alur Sewa**: pilih tanggal → preview kontrak → tanda tangan digital → submit pengajuan
- **Riwayat Sewa**: 4 tab (Semua/Menunggu/Diterima/Ditolak), batalkan booking, lihat garasi
- **Profil**: edit profil, ubah password, riwayat sewa, logout

---

## Arsitektur

```
lib/
├── main.dart                              # Entry point, inisialisasi DB & controller
├── app/
│   ├── routes/
│   │   ├── app_routes.dart                # 19 route constants
│   │   └── app_pages.dart                 # GetPage mapping
│   └── theme/
│       ├── app_colors.dart                # Color palette
│       ├── app_theme.dart                 # ThemeData Material 3
│       └── app_text_styles.dart           # Text style definitions
├── core/
│   ├── utils/
│   │   ├── app_constants.dart             # DB name, session keys, status constants
│   │   ├── session_manager.dart           # SharedPreferences wrapper
│   │   └── password_helper.dart           # SHA-256 hash & verify
│   └── widgets/
│       ├── app_button.dart                # Reusable button (filled/outline/loading)
│       ├── app_text_field.dart            # Reusable text field
│       ├── app_status_badge.dart          # Status badge widget
│       ├── garage_card.dart               # Garage listing card
│       └── section_title.dart             # Section title widget
├── data/
│   ├── models/
│   │   ├── user_model.dart                # User (id, name, email, phone, password, role, imagePath)
│   │   ├── garage_model.dart              # Garage (id, ownerId, name, address, city, dimensi, harga, status, fasilitas)
│   │   ├── rental_model.dart              # Rental (id, garageId, renterId, ownerId, dates, totalPrice, status)
│   │   └── contract_model.dart            # Contract (id, rentalId, contractNumber, data pihak, signature, terms)
│   ├── datasources/local/
│   │   ├── database_helper.dart           # SQLite init, 5 tabel, seed data
│   │   ├── user_local_datasource.dart     # CRUD users + password hash/verify
│   │   ├── garage_local_datasource.dart   # CRUD garages + facilities (transaction)
│   │   ├── rental_local_datasource.dart   # CRUD rentals (JOIN query)
│   │   └── contract_local_datasource.dart # CRUD contracts
│   ├── repositories/
│   │   ├── user_repository.dart           # User operations
│   │   ├── garage_repository.dart         # Garage operations
│   │   ├── rental_repository.dart         # Rental + approve/reject/cancel (transaction)
│   │   └── contract_repository.dart       # Contract + generate nomor
│   └── dummy/
│       └── dummy_data.dart                # Legacy enums & wrapper models
└── presentation/
    ├── splash/splash_screen.dart          # Animasi splash + session check
    ├── auth/
    │   ├── login_page.dart                # Form login + akun demo
    │   ├── register_page.dart             # Form register + role selection
    │   └── controllers/auth_controller.dart
    ├── owner/
    │   ├── dashboard/owner_dashboard_page.dart  # 4 tab (Home/Garasi/Booking/Profil)
    │   ├── garage/
    │   │   ├── owner_garage_list_page.dart      # Daftar garasi owner
    │   │   └── owner_garage_form_page.dart      # Form tambah/edit garasi + fasilitas
    │   ├── booking/owner_booking_page.dart       # Booking masuk (3 tab)
    │   ├── rental_history/owner_rental_history_page.dart
    │   └── controllers/
    │       ├── owner_dashboard_controller.dart
    │       ├── owner_garage_controller.dart
    │       └── owner_booking_controller.dart
    ├── renter/
    │   ├── home/renter_home_page.dart           # 4 tab (Home/Cari/Booking/Profil)
    │   ├── search/renter_search_page.dart       # Search + filter harga
    │   ├── rental_history/renter_rental_history_page.dart
    │   └── controllers/
    │       ├── renter_home_controller.dart
    │       └── renter_booking_controller.dart
    ├── garage/
    │   ├── garage_detail_page.dart              # Detail garasi (shared owner/renter)
    │   └── controllers/garage_detail_controller.dart
    ├── rental/
    │   ├── rental_apply_page.dart               # Form pengajuan sewa
    │   ├── rental_contract_page.dart            # Preview kontrak
    │   ├── rental_signature_page.dart           # Tanda tangan digital
    │   └── controllers/
    │       ├── rental_apply_controller.dart
    │       ├── rental_contract_controller.dart
    │       └── rental_signature_controller.dart
    └── profile/
        ├── profile_page.dart                    # Profil standalone
        ├── edit_profile_page.dart               # Edit profil + foto
        ├── change_password_page.dart            # Ubah password
        └── controllers/profile_controller.dart
```

---

## Database Schema

5 tabel SQLite dengan foreign keys:

```sql
-- Users (dengan password SHA-256 hash)
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  phone TEXT NOT NULL,
  password TEXT NOT NULL,              -- SHA-256 hash (64 karakter)
  role TEXT NOT NULL CHECK(role IN ('owner', 'renter')),
  image_path TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Garages
CREATE TABLE garages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  owner_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  city TEXT DEFAULT 'Solo',
  length REAL NOT NULL,
  width REAL NOT NULL,
  price_per_month INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'available' CHECK(status IN ('available', 'rented')),
  road_access TEXT NOT NULL,
  description TEXT,
  image_path TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(owner_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Garage Facilities
CREATE TABLE garage_facilities (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  garage_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  FOREIGN KEY(garage_id) REFERENCES garages(id) ON DELETE CASCADE
);

-- Rentals
CREATE TABLE rentals (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  garage_id INTEGER NOT NULL,
  renter_id INTEGER NOT NULL,
  owner_id INTEGER NOT NULL,
  start_date TEXT NOT NULL,
  end_date TEXT NOT NULL,
  total_price INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK(status IN ('pending', 'accepted', 'rejected', 'cancelled')),
  note TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(garage_id) REFERENCES garages(id),
  FOREIGN KEY(renter_id) REFERENCES users(id),
  FOREIGN KEY(owner_id) REFERENCES users(id)
);

-- Contracts
CREATE TABLE contracts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  rental_id INTEGER NOT NULL UNIQUE,
  contract_number TEXT NOT NULL UNIQUE,
  owner_name TEXT NOT NULL,
  owner_email TEXT NOT NULL,
  owner_phone TEXT NOT NULL,
  renter_name TEXT NOT NULL,
  renter_email TEXT NOT NULL,
  renter_phone TEXT NOT NULL,
  garage_name TEXT NOT NULL,
  garage_address TEXT NOT NULL,
  start_date TEXT NOT NULL,
  end_date TEXT NOT NULL,
  total_price INTEGER NOT NULL,
  note TEXT,
  renter_signature_path TEXT,
  owner_signature_path TEXT,
  terms_text TEXT NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(rental_id) REFERENCES rentals(id) ON DELETE CASCADE
);
```

### Seed Data
| Tabel | Data |
|-------|------|
| users | 2 akun demo (owner + renter) |
| garages | 3 garasi di Solo |
| garage_facilities | 9 fasilitas (3 per garasi) |

---

## Alur Navigasi

```
Splash (3 detik) → Session Check
  ├─ Session ada + owner → /owner/dashboard
  ├─ Session ada + renter → /renter/home
  └─ Tidak ada session → /login
       ├─ /login → /register (atau sebaliknya)
       └─ Login berhasil:
            ├─ Owner → /owner/dashboard (4 tab)
            │    ├─ Home: statistik, FAB "Tambah Garasi"
            │    ├─ Garasi: daftar → detail → edit/hapus
            │    ├─ Booking: terima/tolak → refresh dashboard
            │    └─ Profil: edit, password, garasi, booking, riwayat, logout
            │
            └─ Renter → /renter/home (4 tab)
                 ├─ Home: kategori → filter, unggulan → detail
                 ├─ Cari: search + filter harga
                 ├─ Booking: riwayat, batalkan, lihat garasi
                 └─ Profil: edit, password, riwayat, logout

Rental Flow (Renter):
  /rental/apply → pilih tanggal, catatan
    → /rental/contract → preview kontrak
      → /rental/signature → tanda tangan digital
        → submit → create rental + contract → /renter/home
```

---

## Routing (19 Route)

| Route | Page | Role |
|-------|------|------|
| `/splash` | SplashScreen | - |
| `/login` | LoginPage | - |
| `/register` | RegisterPage | - |
| `/owner/dashboard` | OwnerDashboardPage | Owner |
| `/owner/garages` | OwnerGarageListPage | Owner |
| `/owner/garages/add` | OwnerGarageFormPage | Owner |
| `/owner/garages/edit` | OwnerGarageFormPage | Owner |
| `/owner/bookings` | OwnerBookingPage | Owner |
| `/owner/rental-history` | OwnerRentalHistoryPage | Owner |
| `/renter/home` | RenterHomePage | Renter |
| `/renter/search` | RenterSearchPage | Renter |
| `/garage/detail` | GarageDetailPage | Shared |
| `/rental/apply` | RentalApplyPage | Renter |
| `/rental/contract` | RentalContractPage | Renter |
| `/rental/signature` | RentalSignaturePage | Renter |
| `/renter/rental-history` | RenterRentalHistoryPage | Renter |
| `/profile` | ProfilePage | Shared |
| `/profile/edit` | EditProfilePage | Shared |
| `/profile/change-password` | ChangePasswordPage | Shared |

---

## Shared Widgets

| Widget | Fungsi |
|--------|--------|
| `AppButton` | Tombol aksi (filled/outline, loading state, icon, custom color) |
| `AppTextField` | Input teks dengan label, hint, validasi, prefix/suffix icon |
| `AppStatusBadge` | Badge status (Menunggu/Diterima/Ditolak/Tersedia/Disewa) |
| `GarageCard` | Kartu listing garasi (gambar, status, nama, lokasi, dimensi, harga) |
| `SectionTitle` | Row title + optional action label |

---

## Unit Test

34 test case mencakup semua CRUD operations:

```
flutter test
```

| Group | Tests | Coverage |
|-------|-------|----------|
| USER CRUD | 11 | Register, login, get by ID/email, update profile, change password, password hash verify |
| GARAGE CRUD | 11 | Create with facilities, read all/available/by owner, search, filter price, update, delete |
| RENTAL CRUD | 7 | Create, read by renter/owner, approve (transaction), reject (transaction), cancel (transaction) |
| CONTRACT CRUD | 5 | Create, read by rental ID, update signature paths, unique contract number |

---

## Menjalankan Aplikasi

```bash
# Clone repository
git clone <repository-url>
cd GarasiIn

# Install dependencies
flutter pub get

# Jalankan aplikasi
flutter run

# Jalankan test
flutter test

# Analisis kode
flutter analyze
```

### Akun Demo

| Peran | Email | Password |
|-------|-------|----------|
| Pemilik | `pemilik@gmail.com` | `123456` |
| Penyewa | `penyewa@gmail.com` | `123456` |

> Password di-hash SHA-256 sebelum disimpan ke database.

---

## Tech Stack

| Dependency | Versi | Kegunaan |
|------------|-------|----------|
| `flutter` | SDK >=3.0.0 <4.0.0 | Framework UI |
| `get` | ^4.6.6 | State management, routing, DI, snackbar, dialog |
| `iconsax` | ^0.0.8 | Library ikon |
| `intl` | ^0.19.0 | Format tanggal & mata uang IDR |
| `signature` | ^5.4.0 | Widget tanda tangan digital |
| `image_picker` | ^1.0.7 | Pilih foto dari kamera/galeri |
| `sqflite` | ^2.3.0 | Database SQLite lokal |
| `path` | ^1.8.3 | Path manipulation |
| `path_provider` | ^2.1.1 | Path direktori aplikasi |
| `shared_preferences` | ^2.2.2 | Session management |
| `crypto` | ^3.0.3 | SHA-256 password hashing |

### Dev Dependencies

| Dependency | Versi | Kegunaan |
|------------|-------|----------|
| `flutter_test` | SDK | Unit testing |
| `sqflite_common_ffi` | ^2.3.0 | SQLite FFI untuk testing |

---

## Design System

### Warna

| Token | Kode | Penggunaan |
|-------|------|------------|
| `primary` | `#2F6B4F` | Tombol, tautan, aksen |
| `primaryDark` | `#1F4D39` | Gradient, header gelap |
| `accent` | `#A8D5BA` | Ikon placeholder |
| `background` | `#FAFAF7` | Latar scaffold |
| `surface` | `#FFFFFF` | Kartu, kontainer |
| `softSurface` | `#F1F5F2` | Input fill, placeholder |
| `textPrimary` | `#111827` | Teks utama |
| `textSecondary` | `#6B7280` | Teks sekunder |
| `border` | `#E5E7EB` | Border, divider |
| `warning` | `#F59E0B` | Status menunggu |
| `success` | `#22C55E` | Status diterima/tersedia |
| `danger` | `#EF4444` | Status ditolak, logout |

---

## Statistik Kode

| Metrik | Jumlah |
|--------|--------|
| Total file Dart | 56 |
| Route | 19 |
| GetX Controller | 11 |
| Model | 4 |
| Repository | 4 |
| Datasource | 5 |
| Shared Widget | 5 |
| Database Table | 5 |
| Unit Test | 34 |

---

## Lisensi

Proyek ini dibuat untuk keperluan pengembangan dan pembelajaran.

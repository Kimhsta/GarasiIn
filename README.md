# GarasiIn

**Marketplace Sewa Garasi Rumah untuk Parkir Mobil**

GarasiIn adalah aplikasi mobile marketplace yang menghubungkan pemilik garasi rumah yang tidak terpakai dengan penyewa yang membutuhkan tempat parkir mobil. Dibangun dengan Flutter + GetX, mendukung dua peran: **Pemilik Garasi** dan **Penyewa**.

**Stack**: Flutter · Dart · GetX · SQLite (rencana) · Clean Architecture (rencana)

---

## Daftar Halaman

Total: **22 file Dart**, ~6.500 baris kode, **19 route**, 4 widget shared, 3 model, 22 TextEditingController.

| # | Halaman | File | Baris | Role | Status |
|---|---------|------|-------|------|--------|
| 1 | Splash Screen | `presentation/splash/splash_screen.dart` | 139 | Keduanya | Aktif |
| 2 | Login | `presentation/auth/login_page.dart` | 195 | Keduanya | Aktif |
| 3 | Register | `presentation/auth/register_page.dart` | 292 | Keduanya | Aktif |
| 4 | Owner Dashboard (4 tab) | `presentation/owner/dashboard/owner_dashboard_page.dart` | 1459 | Pemilik | Aktif |
| 5 | Owner Garage List | `presentation/owner/garage/owner_garage_list_page.dart` | 76 | Pemilik | Aktif |
| 6 | Owner Garage Form | `presentation/owner/garage/owner_garage_form_page.dart` | 291 | Pemilik | Aktif |
| 7 | Owner Booking | `presentation/owner/booking/owner_booking_page.dart` | 245 | Pemilik | Tombol accept/reject kosong |
| 8 | Owner Rental History | `presentation/owner/rental_history/owner_rental_history_page.dart` | 100 | Pemilik | Aktif |
| 9 | Renter Home (4 tab) | `presentation/renter/home/renter_home_page.dart` | 1425 | Penyewa | Aktif |
| 10 | Renter Search | `presentation/renter/search/renter_search_page.dart` | 179 | Penyewa | Tidak dipakai (duplikat embedded) |
| 11 | Renter Rental History | `presentation/renter/rental_history/renter_rental_history_page.dart` | 159 | Penyewa | Tidak dipakai (duplikat embedded) |
| 12 | Garage Detail | `presentation/garage/garage_detail_page.dart` | 275 | Keduanya | Aktif |
| 13 | Rental Apply | `presentation/rental/rental_apply_page.dart` | 319 | Penyewa | Aktif |
| 14 | Rental Contract | `presentation/rental/rental_contract_page.dart` | 241 | Penyewa | Aktif |
| 15 | Rental Signature | `presentation/rental/rental_signature_page.dart` | 237 | Penyewa | Data kontrak tidak diteruskan |
| 16 | Profile (standalone) | `presentation/profile/profile_page.dart` | 303 | Keduanya | Tidak dipakai (duplikat embedded) |
| 17 | Edit Profile | `presentation/profile/edit_profile_page.dart` | 273 | Keduanya | Aktif |
| 18 | Change Password | `presentation/profile/change_password_page.dart` | 174 | Keduanya | Aktif |

---

## Alur Navigasi

```
Splash (3 detik)
  │
  ▼
Login ──────────────────────────────────────────────────────────
  │                                                             │
  │ email: pemilik@gmail.com                                    │ email: lainnya
  ▼                                                             ▼
Owner Dashboard (4 tab)                              Renter Home (4 tab)
  ├─ Home: statistik, booking masuk, garasi saya       ├─ Home: hero, kategori, unggulan
  ├─ Garasi: daftar garasi + tambah                    ├─ Cari: search + filter harga
  ├─ Booking: terima/tolak                             ├─ Booking: riwayat sewa
  └─ Profil: ubah profil, password, logout             └─ Profil: ubah profil, password, logout
       │                                                    │
       ├─ Garasi Detail ◄───────────────────────────────────┤
       │       │                                            │
       │       └─► Rental Apply (pilih tanggal)             │
       │               │                                    │
       │               └─► Rental Contract (review)         │
       │                       │                            │
       │                       └─► Rental Signature         │
       │                               │                    │
       │                               └─► Renter Home ─────┘
       │
       ├─ Edit Profile
       ├─ Change Password
       └─ Logout → Login
```

---

## Fungsi Setiap Halaman

### Splash Screen
- Animasi fade-in logo "GarasiIn" dengan tagline "Sewa garasi lebih mudah"
- Auto-navigate ke Login setelah 3 detik

### Login
- Form input: Email, Password
- Routing otomatis: `pemilik@gmail.com` → Dashboard Pemilik, lainnya → Home Penyewa
- Link ke halaman Register
- Info box akun demo

### Register
- Form input: Nama Lengkap, Email, Nomor HP, Password
- Pilih peran: kartu "Pemilik Garasi" atau "Penyewa"
- Auto-navigate sesuai role yang dipilih

### Owner Dashboard (4 Tab)

**Tab Home:**
- Hero banner dengan greeting nama pemilik
- 4 kartu statistik: Total Garasi, Booking Masuk, Disewa, Tersedia
- Carousel booking yang menunggu konfirmasi
- Daftar garasi milik pemilik

**Tab Garasi:**
- Daftar garasi dengan tombol edit
- Tombol "Tambah Garasi Baru"

**Tab Booking:**
- TabBar: Menunggu | Diterima | Ditolak
- Kartu booking dengan tombol Terima/Tolak + dialog konfirmasi

**Tab Profil:**
- Header: avatar, nama, email, badge "Pemilik Garasi"
- Menu: Ubah Profil, Ubah Password, Garasi Saya, Booking Masuk, Riwayat Penyewaan, Logout

### Owner Garage Form
- Mode tambah atau edit (parameter `isEdit`)
- Input: Nama Garasi, Alamat, Panjang, Lebar, Harga Sewa/bulan, Akses Jalan, Deskripsi
- Upload foto (placeholder, belum fungsional)

### Renter Home (4 Tab)

**Tab Home:**
- Hero banner: "Hi, Andi" + search bar stub
- 4 kategori: Terdekat, Populer, Murah, Premium
- Carousel garasi unggulan
- Daftar garasi terbaru

**Tab Cari:**
- Search field dengan autofokus
- Filter harga: Semua, < Rp300rb, Rp300-500rb, > Rp500rb
- Hasil pencarian menggunakan GarageCard

**Tab Booking:**
- TabBar: Semua | Menunggu | Diterima | Ditolak
- Kartu booking dengan detail di bottom sheet
- Aksi: Batalkan (menunggu), Lihat Garasi (diterima), Ajukan Lagi (ditolak)

**Tab Profil:**
- Header: avatar, nama, email, badge "Penyewa"
- Menu: Ubah Profil, Ubah Password, Riwayat Sewa, Logout

### Garage Detail
- Info lengkap: gambar, nama, lokasi, harga/bulan
- Dimensi carport (Panjang x Lebar x Luas)
- Akses jalan, deskripsi, fasilitas (badge)
- Tombol "Ajukan Sewa" (disabled jika sudah disewa)

### Rental Apply (4 Langkah)
1. **Ajukan Sewa**: pilih tanggal mulai/selesai, catatan untuk pemilik, ringkasan harga
2. **Kontrak Sewa**: review data pemilik & penyewa, info garasi, periode, syarat & ketentuan
3. **Tanda Tangan**: canvas tanda tangan digital
4. **Selesai**: kirim pengajuan, kembali ke home

### Edit Profile
- Avatar dengan ikon kamera (tap untuk pilih dari Kamera/Galeri)
- Input: Nama Lengkap, Email, No. Telepon

### Change Password
- Ikon gembok + instruksi
- Input: Password Lama, Password Baru (min 6 char), Konfirmasi Password
- Toggle visibility untuk setiap field

---

## Tombol yang Ada

| Halaman | Tombol | Aksi |
|---------|--------|------|
| Login | "Masuk" | Validasi form → navigasi sesuai role |
| Login | "Daftar Akun" | Navigasi ke Register |
| Register | "Daftar Sekarang" | Validasi form → navigasi sesuai role |
| Register | "Sudah punya akun? Masuk" | Kembali ke Login |
| Owner Home | FAB "Tambah Garasi" | Navigasi ke Garage Form (add) |
| Owner Booking | "Terima" | Dialog konfirmasi → snackbar berhasil |
| Owner Booking | "Tolak" | Dialog konfirmasi → snackbar berhasil |
| Garage Detail | "Ajukan Sewa" | Navigasi ke Rental Apply (disabled jika rented) |
| Rental Apply | "Lanjut ke Kontrak" | Validasi tanggal → navigasi ke Contract |
| Rental Contract | "Lanjut Tanda Tangan" | Navigasi ke Signature |
| Rental Signature | "Hapus Tanda Tangan" | Reset canvas |
| Rental Signature | "Kirim Pengajuan" | Validasi tanda tangan → navigasi ke Home |
| Edit Profile | "Simpan Perubahan" | Validasi form → snackbar berhasil |
| Edit Profile | Ikon kamera | Bottom sheet pilih Kamera/Galeri |
| Change Password | "Simpan Password" | Validasi form → snackbar berhasil |
| Semua halaman | Tombol back (AppBar) | `Get.back()` |
| Profil (kedua role) | "Logout" | Dialog konfirmasi → navigasi ke Login |

---

## Form Input yang Ada

| Halaman | Field | Tipe | Validasi |
|---------|-------|------|----------|
| **Login** | Email | `emailAddress` | Wajib isi |
| | Password | `obscureText` | Wajib isi |
| **Register** | Nama Lengkap | `name` | Wajib isi |
| | Email | `emailAddress` | Wajib isi |
| | Nomor HP | `phone` | Wajib isi |
| | Password | `obscureText` | Min 6 karakter |
| | Pilih Peran | Card selector | Visual toggle |
| **Garage Form** | Nama Garasi | `text` | Wajib isi |
| | Alamat Lengkap | `text` | Wajib isi |
| | Panjang (m) | `number` | Wajib isi |
| | Lebar (m) | `number` | Wajib isi |
| | Harga Sewa/bulan (Rp) | `number` | Wajib isi |
| | Kondisi Akses Jalan | `text` | Wajib isi |
| | Deskripsi | `text` (multiline) | Opsional |
| **Rental Apply** | Tanggal Mulai | Date picker | Wajib isi |
| | Tanggal Selesai | Date picker | Wajib isi |
| | Catatan untuk Pemilik | `text` (multiline) | Opsional |
| **Edit Profile** | Nama Lengkap | `name` | Wajib isi |
| | Email | `emailAddress` | Wajib isi + format @ |
| | No. Telepon | `phone` | Wajib isi |
| | Foto Profil | Image picker | Opsional |
| **Change Password** | Password Lama | `obscureText` | Wajib isi |
| | Password Baru | `obscureText` | Min 6 karakter |
| | Konfirmasi Password | `obscureText` | Harus cocok |
| **Rental Signature** | Tanda Tangan | Signature pad | Wajib ada |

---

## UI Pemilik Garasi

| Halaman | Fungsi | Data yang Ditampilkan |
|---------|--------|----------------------|
| Dashboard - Home | Overview statistik | Total garasi, booking masuk, disewa, tersedia, pending bookings, daftar garasi |
| Dashboard - Garasi | Kelola daftar garasi | Garasi milik pemilik dengan tombol edit |
| Dashboard - Booking | Kelola booking | Booking masuk dengan tab status + tombol terima/tolak |
| Dashboard - Profil | Pengaturan akun | Avatar, nama, email, badge role, menu navigasi |
| Garage Form | Tambah/edit garasi | Form 7 field + foto placeholder |
| Booking Page | Lihat booking masuk | Daftar booking dengan tab status |
| Rental History | Riwayat penyewaan | Semua booking dengan status |

---

## UI Penyewa

| Halaman | Fungsi | Data yang Ditampilkan |
|---------|--------|----------------------|
| Home - Home | Jelajahi garasi | Greeting, kategori, garasi unggulan, garasi terbaru |
| Home - Cari | Cari garasi | Search + filter harga + hasil pencarian |
| Home - Booking | Riwayat sewa | Booking dengan tab status + detail di bottom sheet |
| Home - Profil | Pengaturan akun | Avatar, nama, email, badge role, menu navigasi |
| Garage Detail | Lihat detail garasi | Info lengkap garasi + tombol ajukan sewa |
| Rental Apply | Form pengajuan | Pilih tanggal, catatan, ringkasan harga |
| Rental Contract | Review kontrak | Data pemilik, penyewa, garasi, periode, syarat |
| Rental Signature | Tanda tangan | Canvas tanda tangan digital |

---

## Data yang Masih Dummy (Hardcoded)

| Data | Lokasi | Nilai Hardcode |
|------|--------|----------------|
| User pemilik | `DummyData.ownerUser` | Budi Santoso, `pemilik@gmail.com`, `0812-3456-7890` |
| User penyewa | `DummyData.renterUser` | Andi Pratama, `penyewa@gmail.com`, `0856-7890-1234` |
| Login routing | `login_page.dart:37` | Email `pemilik@gmail.com` → owner, lainnya → renter |
| Garasi | `DummyData.garages` | 3 garasi di Solo (`g001`, `g002`, `g003`) |
| Booking | `DummyData.bookings` | 3 booking (`b001` pending, `b002` accepted, `b003` rejected) |
| Rating | `renter_home_page.dart:437` | Hardcode `'4.8'` di semua kartu garasi |
| Nama penyewa di signature | `rental_signature_page.dart:123` | Hardcode `'Andi Pratama'` |
| Data garasi di edit form | `owner_garage_form_page.dart:36` | Selalu load `DummyData.garages.first` (BUG) |
| Semua operasi CRUD | Semua halaman form | `Future.delayed(1 detik)` → snackbar, tidak ada penyimpanan |
| Kontrak number | `rental_contract_page.dart` | Generate dari `millisecondsSinceEpoch` |
| Syarat & Ketentuan | `rental_contract_page.dart` | 5 poin hardcode |

---

## Bagian yang Perlu Disambungkan ke SQLite

### Kritis (Langsung Perlu)

| Fitur | Halaman | Operasi SQLite |
|-------|---------|----------------|
| Login | `LoginPage` | `SELECT users WHERE email=? AND password=?` |
| Register | `RegisterPage` | `INSERT INTO users` |
| Tambah Garasi | `OwnerGarageFormPage` | `INSERT INTO garages` |
| Edit Garasi | `OwnerGarageFormPage` | `UPDATE garages WHERE id=?` |
| Hapus Garasi | `OwnerDashboardPage` | `DELETE FROM garages WHERE id=?` |
| Terima Booking | `OwnerDashboardPage` | `UPDATE rentals SET status='accepted' WHERE id=?` |
| Tolak Booking | `OwnerDashboardPage` | `UPDATE rentals SET status='rejected' WHERE id=?` |
| Ajukan Sewa | `RentalApplyPage` + `RentalSignaturePage` | `INSERT INTO rentals` + `INSERT INTO contracts` |
| Ubah Profil | `EditProfilePage` | `UPDATE users WHERE id=?` |
| Ubah Password | `ChangePasswordPage` | `UPDATE users SET password=? WHERE id=?` |
| Daftar Garasi | `OwnerDashboardPage`, `RenterHomePage` | `SELECT garages` |
| Riwayat Booking | `OwnerDashboardPage`, `RenterHomePage` | `SELECT rentals WHERE owner_id=? OR renter_id=?` |

### Bug yang Perlu Diperbaiki

| Bug | Lokasi | Perbaikan |
|-----|--------|-----------|
| Edit garasi tidak terima argumen | `owner_garage_form_page.dart:36` | Terima `GarageModel` via `Get.arguments` |
| Data kontrak hilang di signature | `rental_contract_page.dart` → `rental_signature_page.dart` | Teruskan data kontrak via arguments |
| Accept/reject di standalone booking kosong | `owner_booking_page.dart` | Implementasi logika yang sama dengan dashboard |

---

## Rencana Backend SQLite

### Stack yang Dibutuhkan

```
sqflite          → Database SQLite
path_provider    → Path direktori database
shared_preferences → Simpan sesi login (user ID aktif)
```

### Struktur Database

#### Tabel `users`
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  phone TEXT NOT NULL,
  password TEXT NOT NULL,
  role TEXT NOT NULL CHECK(role IN ('owner', 'renter')),
  image_path TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);
```

#### Tabel `garages`
```sql
CREATE TABLE garages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  owner_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  city TEXT NOT NULL,
  length REAL NOT NULL,
  width REAL NOT NULL,
  price_per_month INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'available' CHECK(status IN ('available', 'rented')),
  road_access TEXT NOT NULL,
  description TEXT,
  image_path TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
);
```

#### Tabel `garage_facilities`
```sql
CREATE TABLE garage_facilities (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  garage_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  FOREIGN KEY (garage_id) REFERENCES garages(id) ON DELETE CASCADE
);
```

#### Tabel `rentals`
```sql
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
  FOREIGN KEY (garage_id) REFERENCES garages(id),
  FOREIGN KEY (renter_id) REFERENCES users(id),
  FOREIGN KEY (owner_id) REFERENCES users(id)
);
```

#### Tabel `contracts`
```sql
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
  signature_path TEXT,
  terms_text TEXT NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (rental_id) REFERENCES rentals(id) ON DELETE CASCADE
);
```

### Arsitektur Clean Architecture (Rencana)

```
lib/
├── app/
│   ├── routes/              # Sudah ada
│   ├── theme/               # Sudah ada
│   └── bindings/            # BARU - GetX Bindings per halaman
│
├── core/
│   ├── widgets/             # Sudah ada
│   └── utils/               # BARU - Session manager, constants
│
├── data/
│   ├── datasources/local/   # BARU - DatabaseHelper, CRUD per tabel
│   ├── models/              # BARU - Model + toMap/fromMap
│   └── repositories/        # BARU - Implementasi repository
│
├── domain/
│   ├── entities/            # BARU - Entity class
│   └── repositories/        # BARU - Abstract interface repository
│
├── presentation/
│   ├── auth/controllers/    # BARU - LoginController, RegisterController
│   ├── owner/controllers/   # BARU - DashboardController, GarageController, BookingController
│   ├── renter/controllers/  # BARU - HomeController, SearchController, BookingController
│   ├── garage/controllers/  # BARU - GarageDetailController
│   ├── rental/controllers/  # BARU - ApplyController, ContractController, SignatureController
│   └── profile/controllers/ # BARU - EditProfileController, ChangePasswordController
│
└── main.dart
```

---

## File yang Nantinya Perlu Dibuat atau Diubah

### File BARU (30 file)

| # | File | Fungsi |
|---|------|--------|
| 1 | `data/datasources/local/database_helper.dart` | Setup SQLite, CREATE TABLES, migration |
| 2 | `data/datasources/local/user_local_datasource.dart` | CRUD users |
| 3 | `data/datasources/local/garage_local_datasource.dart` | CRUD garages + facilities |
| 4 | `data/datasources/local/rental_local_datasource.dart` | CRUD rentals |
| 5 | `data/datasources/local/contract_local_datasource.dart` | CRUD contracts |
| 6 | `data/models/user_model.dart` | UserModel + toMap/fromMap |
| 7 | `data/models/garage_model.dart` | GarageModel + toMap/fromMap |
| 8 | `data/models/rental_model.dart` | RentalModel + toMap/fromMap |
| 9 | `data/models/contract_model.dart` | ContractModel + toMap/fromMap |
| 10 | `data/repositories/user_repository_impl.dart` | Implementasi UserRepository |
| 11 | `data/repositories/garage_repository_impl.dart` | Implementasi GarageRepository |
| 12 | `data/repositories/rental_repository_impl.dart` | Implementasi RentalRepository |
| 13 | `data/repositories/contract_repository_impl.dart` | Implementasi ContractRepository |
| 14 | `domain/entities/user.dart` | Entity User |
| 15 | `domain/entities/garage.dart` | Entity Garage |
| 16 | `domain/entities/rental.dart` | Entity Rental |
| 17 | `domain/entities/contract.dart` | Entity Contract |
| 18 | `domain/repositories/user_repository.dart` | Abstract interface |
| 19 | `domain/repositories/garage_repository.dart` | Abstract interface |
| 20 | `domain/repositories/rental_repository.dart` | Abstract interface |
| 21 | `domain/repositories/contract_repository.dart` | Abstract interface |
| 22-28 | `app/bindings/*.dart` (7 file) | GetX dependency injection per halaman |
| 29 | `core/utils/session_manager.dart` | Simpan ID user login |
| 30 | `core/utils/constants.dart` | Konstanta aplikasi |

### File yang Perlu DIUBAH (15 file)

| # | File | Perubahan |
|---|------|-----------|
| 1 | `pubspec.yaml` | Tambah `sqflite`, `path_provider`, `shared_preferences` |
| 2 | `main.dart` | Inisialisasi DatabaseHelper, register bindings |
| 3 | `app/routes/app_pages.dart` | Tambah binding ke setiap route |
| 4 | `data/dummy/dummy_data.dart` | Pindahkan model ke `data/models/`, hapus atau jadikan seed data |
| 5 | `presentation/auth/login_page.dart` | Ganti hardcode email → query SQLite |
| 6 | `presentation/auth/register_page.dart` | Ganti mock → INSERT SQLite |
| 7 | `presentation/owner/dashboard/owner_dashboard_page.dart` | Ganti DummyData → controller/repository |
| 8 | `presentation/owner/garage/owner_garage_form_page.dart` | Fix bug edit, ganti mock → CRUD SQLite |
| 9 | `presentation/owner/booking/owner_booking_page.dart` | Implementasi accept/reject (UPDATE status) |
| 10 | `presentation/renter/home/renter_home_page.dart` | Ganti DummyData → controller/repository |
| 11 | `presentation/garage/garage_detail_page.dart` | Ganti DummyData → arguments dari controller |
| 12 | `presentation/rental/rental_apply_page.dart` | Ganti mock → INSERT rental SQLite |
| 13 | `presentation/rental/rental_contract_page.dart` | Teruskan data ke signature page |
| 14 | `presentation/rental/rental_signature_page.dart` | Terima data kontrak, INSERT contract SQLite |
| 15 | `presentation/profile/edit_profile_page.dart` | Ganti mock → UPDATE users SQLite |

---

## Data Model (Saat Ini)

### UserModel
| Field | Tipe | Deskripsi |
|---|---|---|
| `id` | String | ID unik |
| `name` | String | Nama lengkap |
| `email` | String | Alamat email |
| `phone` | String | Nomor telepon |
| `role` | UserRole | `owner` atau `renter` |

### GarageModel
| Field | Tipe | Deskripsi |
|---|---|---|
| `id` | String | ID unik |
| `ownerId` | String | ID pemilik |
| `name` | String | Nama garasi |
| `address` | String | Alamat |
| `city` | String | Kota |
| `length` | double | Panjang (meter) |
| `width` | double | Lebar (meter) |
| `pricePerMonth` | int | Harga sewa/bulan (IDR) |
| `status` | GarageStatus | `available` atau `rented` |
| `roadAccess` | String | Kondisi akses jalan |
| `description` | String | Deskripsi lengkap |
| `facilities` | List\<String\> | Daftar fasilitas |
| `imageUrl` | String | Path gambar |

### BookingModel
| Field | Tipe | Deskripsi |
|---|---|---|
| `id` | String | ID unik |
| `garageId` | String | ID garasi |
| `garageName` | String | Nama garasi (denormalized) |
| `renterId` | String | ID penyewa |
| `renterName` | String | Nama penyewa (denormalized) |
| `ownerId` | String | ID pemilik |
| `startDate` | DateTime | Tanggal mulai sewa |
| `endDate` | DateTime | Tanggal akhir sewa |
| `totalPrice` | int | Total biaya (IDR) |
| `status` | BookingStatus | `pending`, `accepted`, `rejected` |
| `note` | String? | Catatan dari penyewa |

---

## Shared Widgets

| Widget | File | Fungsi |
|--------|------|--------|
| `AppButton` | `core/widgets/app_button.dart` | Tombol aksi (filled/outline, loading state, icon) |
| `AppTextField` | `core/widgets/app_text_field.dart` | Input teks dengan label, validasi, prefix/suffix icon |
| `AppStatusBadge` | `core/widgets/app_status_badge.dart` | Badge status booking/garasi (Menunggu/Diterima/Ditolak/Tersedia/Disewa) |
| `GarageCard` | `core/widgets/garage_card.dart` | Kartu listing garasi (navigasi ke detail, tombol edit) |

---

## Design System

### Warna

| Token | Kode | Penggunaan |
|---|---|---|
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

### Tipografi

| Gaya | Ukuran | Bobot | Penggunaan |
|---|---|---|---|
| `displayLarge` | 28px | Bold | Judul splash |
| `displayMedium` | 22px | Bold | Judul halaman |
| `headingLarge` | 20px | Semi-bold | Hero text |
| `headingMedium` | 17px | Semi-bold | AppBar, nama kartu |
| `headingSmall` | 15px | Semi-bold | Sub-section |
| `bodyMedium` | 14px | Regular | Teks utama |
| `bodySmall` | 12px | Regular | Deskripsi |
| `labelLarge` | 14px | Medium | Label tombol |
| `price` | 16px | Bold | Harga (hijau) |
| `caption` | 11px | Regular | Teks terkecil |

---

## Tech Stack

| Dependency | Versi | Kegunaan |
|---|---|---|
| `flutter` | SDK 3.x | Framework UI |
| `get` | ^4.6.6 | Routing, state management, snackbar, dialog, bottom sheet |
| `iconsax` | ^0.0.8 | Library ikon |
| `intl` | ^0.19.0 | Format tanggal & mata uang IDR |
| `signature` | ^5.4.0 | Widget tanda tangan digital |
| `image_picker` | ^1.0.7 | Pilih foto dari kamera/galeri |

### Dependency Rencana (untuk SQLite)

| Dependency | Kegunaan |
|---|---|
| `sqflite` | Database SQLite lokal |
| `path_provider` | Path direktori database |
| `shared_preferences` | Simpan sesi login (user ID aktif) |

---

## Bug & Masalah yang Ditemukan

| # | Masalah | Lokasi | Severity |
|---|---------|--------|----------|
| 1 | Edit garasi selalu load `DummyData.garages.first`, bukan dari arguments | `owner_garage_form_page.dart:36` | High |
| 2 | Data kontrak tidak diteruskan ke halaman signature | `rental_contract_page.dart` → `rental_signature_page.dart` | High |
| 3 | Accept/reject booking di standalone page kosong (`onTap: () {}`) | `owner_booking_page.dart` | Medium |
| 4 | 3 halaman tidak dipakai (duplikat embedded) | `renter_search_page`, `renter_rental_history_page`, `profile_page` | Medium |
| 5 | `flutter_test` di `dependencies` instead of `dev_dependencies` | `pubspec.yaml` | Low |
| 6 | Login routing hardcode email, bukan query database | `login_page.dart:37` | High (saat integrasi SQLite) |
| 7 | Nama penyewa hardcode di halaman signature | `rental_signature_page.dart:123` | Medium |

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
```

### Akun Demo

| Peran | Email | Password |
|---|---|---|
| Pemilik | `pemilik@gmail.com` | (bebas) |
| Penyewa | `penyewa@gmail.com` | (bebas) |

> Password bisa diisi apa saja karena ini prototype frontend tanpa backend.

---

## Catatan Pengembangan

- Aplikasi ini merupakan **prototype frontend** — semua data di-hardcode melalui `DummyData`
- Tidak ada backend, API, atau database yang terintegrasi
- Semua operasi CRUD bersifat simulasi (`Future.delayed` 1 detik)
- Fitur ubah profil dan ubah password bersifat kosmetik
- Foto profil dari kamera/galeri tersedia di halaman Ubah Profil untuk kedua peran
- Untuk build release Android, pastikan `minSdk` >= 21 (diperlukan oleh `image_picker`)
- Arsitektur saat ini: **Presentation-Layer + Feature-Based Hybrid** (belum Clean Architecture)
- Tidak ada GetX Controller, Repository, Service, atau Database Helper

---

## Lisensi

Proyek ini dibuat untuk keperluan pengembangan dan pembelajaran.

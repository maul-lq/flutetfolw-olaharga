# Manual Fitness Tracker Idea

## Ringkasan
Project ini paling cocok dipivot menjadi **Manual Fitness Tracker** dengan dua fokus utama:

1. **Mencatat workout harian**
2. **Mencatat progress tubuh**
   - berat badan
   - tinggi badan

Aplikasi ini tidak berfokus pada booking gym class atau sinkronisasi wearable, tetapi pada **self-tracking manual** yang ringan, cepat, dan mudah dipakai setiap hari.

---

## Kenapa project ini cocok untuk ide ini
Berdasarkan struktur `lib/` saat ini, project sudah punya fondasi UI yang sangat cocok untuk app fitness tracking manual:

- **Dashboard shell** di `lib/main.dart`
- **Home screen** yang cocok dijadikan dashboard progress
- **Upcoming screen** yang cocok dijadikan log/rencana workout
- **Reservation/detail screen** yang cocok dijadikan detail workout
- **Signup** yang bisa dipakai untuk setup profil awal
- **VerifyPhoneNumber** yang bisa dipivot menjadi input progress tubuh
- **Komponen kartu dan popup** yang sudah reusable

Artinya, project ini tidak perlu dimulai dari nol. Struktur visual dan flow dasarnya sudah tersedia.

---

## Mapping screen dari struktur project saat ini

### 1. Home -> Dashboard
Gunakan `Home` sebagai halaman utama untuk menampilkan ringkasan kondisi user hari ini.

**Isi yang cocok:**
- workout terakhir
- total workout minggu ini
- total durasi latihan
- streak latihan
- berat badan terbaru
- quick actions:
  - tambah workout
  - tambah progress tubuh

### 2. Upcoming -> Workout Log / Planned Workouts
Gunakan `Upcoming` sebagai halaman untuk melihat workout yang sudah dicatat atau direncanakan.

**Isi yang cocok:**
- daftar workout harian
- planned workouts untuk hari ini / minggu ini
- log workout yang sudah selesai
- filter berdasarkan kategori atau tanggal

### 3. Reservation -> Workout Detail
Gunakan `Reservation` sebagai halaman detail untuk satu workout entry.

**Isi yang cocok:**
- nama workout
- kategori
- durasi
- estimasi kalori
- catatan
- jam latihan
- tombol edit / hapus / tandai selesai

### 4. Signup -> Profile Setup
Gunakan `Signup` untuk setup profil awal user.

**Isi yang cocok:**
- nama user
- tinggi badan
- berat awal
- target mingguan

### 5. VerifyPhoneNumber -> Body Progress Entry
Gunakan `VerifyPhoneNumber` sebagai halaman input progress tubuh.

**Isi yang cocok:**
- berat badan terbaru
- tinggi badan
- tanggal pencatatan
- catatan opsional

---

## Komponen yang paling reusable

### BookCardItemWidget
Bisa dipakai untuk:
- quick workout card
- suggested workout card
- saved routine card

### PriceDropItemsWidget
Bisa dipakai untuk:
- challenge card
- goal card
- reminder card
- weekly highlight

### UpcomingItemWidget
Bisa dipakai untuk:
- next workout card
- planned workout card
- workout summary card

### ConfirmReservationPopupWidget / ConfirmCancelationPopupWidget
Bisa dipakai untuk:
- konfirmasi mulai workout
- konfirmasi selesai workout
- konfirmasi hapus log
- konfirmasi reset data tertentu

---

## Data model yang disarankan

### WorkoutLog
Model utama untuk menyimpan catatan latihan harian.

Field yang disarankan:
- `id`
- `date`
- `workoutName`
- `category`
- `durationMinutes`
- `caloriesBurnedEstimate`
- `notes`
- `intensity`
- `isCompleted`

### BodyMetricEntry
Model utama untuk progress tubuh.

Field yang disarankan:
- `id`
- `date`
- `weightKg`
- `heightCm`
- `note`

### UserProfile
Model data dasar user.

Field yang disarankan:
- `name`
- `heightCm`
- `targetWeightKg`
- `activityGoalPerWeek`

---

## Flow utama user

### Flow 1: Tambah workout harian
1. User buka Dashboard
2. User tap **Add workout**
3. User isi data workout:
   - nama workout
   - kategori
   - durasi
   - estimasi kalori
   - catatan
4. User simpan
5. Workout muncul di Workout Log / History

### Flow 2: Tambah progress tubuh
1. User buka halaman Body Progress
2. User input berat badan terbaru
3. Tinggi badan bisa tetap dari profil atau diperbarui bila perlu
4. User simpan
5. Dashboard menampilkan progress terbaru

### Flow 3: Lihat progress
1. User buka Dashboard
2. User melihat:
   - total latihan minggu ini
   - total menit latihan
   - berat badan terbaru
   - perubahan dibanding entry sebelumnya

---

## Fitur MVP yang direkomendasikan

### MVP 1
Fokus pada fitur paling penting terlebih dahulu:
- tambah workout harian
- lihat daftar workout
- lihat detail workout
- tambah berat badan
- simpan tinggi badan
- dashboard ringkas progress

### MVP 2
Setelah MVP dasar stabil:
- edit / hapus workout
- edit / hapus body progress
- filter workout per tanggal
- summary mingguan
- BMI sederhana

### MVP 3
Fitur lanjutan:
- target mingguan
- streak tracking
- kategori workout analytics
- export data
- reminder latihan

---

## Rekomendasi pendekatan produk
Dari tiga pendekatan umum yang mungkin, rekomendasi terbaik untuk project ini adalah:

## Pendekatan yang direkomendasikan: Pivot sedang
Artinya:
- tetap memakai banyak struktur yang sudah ada
- tapi makna screen dan datanya dipindahkan ke domain fitness tracking
- tidak sekadar rename, tetapi juga memperjelas domain aplikasi

**Kenapa ini yang terbaik:**
- effort masih masuk akal
- reuse komponen tinggi
- hasil produk lebih natural
- tidak terasa seperti app booking yang dipaksa jadi tracker

---

## Rekomendasi implementasi berikutnya
Jika ide ini nanti diimplementasikan, urutan yang paling aman adalah:

1. buat model `WorkoutLog`, `BodyMetricEntry`, `UserProfile`
2. pivot `Home` menjadi dashboard progress
3. pivot `Upcoming` menjadi workout history / planned workouts
4. pivot `Reservation` menjadi workout detail
5. ubah `Signup` dan `VerifyPhoneNumber` menjadi profile setup + body progress
6. tambahkan local persistence

---

## Kesimpulan final
Arah terbaik untuk project ini adalah menjadikannya **Manual Fitness Tracker** dengan dua pilar utama:

- **Workout Log Harian**
- **Body Progress Tracker (berat dan tinggi badan)**

Dengan struktur yang sudah ada di `lib/`, project ini sangat cocok untuk pivot tersebut karena sudah memiliki:
- shell navigasi
- halaman utama
- list screen
- detail screen
- onboarding flow
- reusable card/popup patterns

Jadi idenya bukan membangun aplikasi baru dari nol, melainkan **mengubah fondasi UI yang ada menjadi produk fitness tracking manual yang fokus, ringan, dan mudah dikembangkan.**

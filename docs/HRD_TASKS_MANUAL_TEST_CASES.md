# Test Case Manual – Fitur HRD Tasks (Online & Offline)

Dokumen ini berisi skenario test manual untuk fitur **HRD Tasks** pada mode **online** dan **offline**. Centang (✓) kolom **Pass/Fail** setelah menjalankan setiap test.

**Informasi fitur:**
- **List Tugas HRD**: Daftar semua tugas (`/hrd/hrd_tasks`)
- **Detail Tugas**: Detail satu tugas (judul, tanggal, level, priority, acceptance criteria, assigned to, status)
- **Tugas Hari Ini**: Tugas yang dikelompokkan per user untuk tanggal hari ini
- **Homepage HRD**: Kartu rekap (tugas hari ini, overdue, selesai, todo, on progress) yang mengarah ke list tugas

**Status tugas:** `todo` | `on_progress` | `finished`

---

## Persiapan

| No | Langkah | Pass | Fail |
|----|---------|------|------|
| P1 | Login sebagai user **HRD** | ☐ | ☐ |
| P2 | Pastikan perangkat/emulator bisa diatur ke **Online** (Wi‑Fi/Data) dan **Offline** (airplane mode / matikan jaringan) | ☐ | ☐ |

---

## 1. Mode ONLINE

### 1.1 Mengambil & Menampilkan Daftar Tugas

| ID | Skenario | Langkah | Hasil yang Diharapkan | Pass | Fail |
|----|----------|---------|------------------------|------|------|
| O1.1 | Load daftar tugas saat online | 1. Pastikan perangkat **online**<br>2. Buka **Homepage HRD** → tap area **"Rekap Tugas Karyawan"** / menu **Tugas HRD**<br>3. Masuk ke halaman **Tugas HRD** | Loading tampil sebentar, lalu daftar tugas dari server tampil. Data juga tersimpan ke lokal. | ☐ | ☐ |
| O1.2 | Daftar kosong | 1. Online, pastikan tidak ada tugas di server (atau pakai akun yang memang kosong)<br>2. Buka **Tugas HRD** | Tampil pesan/state **"Belum ada tugas"** (atau setara), tanpa error | ☐ | ☐ |
| O1.3 | Pull/refresh setelah data sudah ada | 1. Online, buka **Tugas HRD** sampai data tampil<br>2. Tambah atau ubah tugas dari sumber lain (e.g. Supabase dashboard / akun lain)<br>3. Kembali ke app, trigger refresh (pull-to-refresh jika ada, atau keluar lalu buka lagi) | Daftar tugas ter-update sesuai data terbaru dari server | ☐ | ☐ |

### 1.2 Rekap di Homepage HRD

| ID | Skenario | Langkah | Hasil yang Diharapkan | Pass | Fail |
|----|----------|---------|------------------------|------|------|
| O2.1 | Rekap tugas di kartu homepage | 1. Online, pastikan ada tugas dengan status beragam (todo, on_progress, finished) dan ada yang jatuh tempo hari ini / overdue<br>2. Buka **Homepage HRD** | Kartu **"Rekap Tugas Karyawan"** menampilkan angka yang masuk akal: tugas hari ini, overdue, selesai, todo, on progress | ☐ | ☐ |
| O2.2 | Tap kartu rekap ke list tugas | 1. Di Homepage HRD, tap kartu rekap tugas<br>2. Perhatikan navigasi | Masuk ke halaman **Tugas HRD** (list) | ☐ | ☐ |

### 1.3 Detail Tugas

| ID | Skenario | Langkah | Hasil yang Diharapkan | Pass | Fail |
|----|----------|---------|------------------------|------|------|
| O3.1 | Buka detail dari list | 1. Online, buka **Tugas HRD**<br>2. Tap salah satu tugas di list | Halaman **Detail Tugas** tampil dengan: judul, tanggal mulai/selesai, level, priority, acceptance criteria, assigned to (jika ada), status (todo / on progress / finished) | ☐ | ☐ |
| O3.2 | Status tampil sesuai data | 1. Pilih tugas yang statusnya **todo**<br>2. Buka detail | Status **Todo** ter-highlight/terpilih di section "Task Status" | ☐ | ☐ |
| O3.3 | (Ulangi untuk status on_progress dan finished) | Buka detail tugas dengan status **on_progress** dan **finished** | Masing-masing tampil sesuai status yang benar | ☐ | ☐ |

### 1.4 Tugas Hari Ini (Grouped)

| ID | Skenario | Langkah | Hasil yang Diharapkan | Pass | Fail |
|----|----------|---------|------------------------|------|------|
| O4.1 | Akses halaman "Grouped Tasks Today" | 1. Online, pastikan ada tugas yang **start_date ≤ hari ini ≤ end_date**<br>2. Navigasi ke **Grouped Tasks Today** / **Tugas Hari Ini** (dari menu atau tab jika ada) | Halaman menampilkan tugas hari ini dikelompokkan per **nama user** (assigned to) | ☐ | ☐ |
| O4.2 | Tidak ada tugas hari ini | 1. Gunakan data di mana tidak ada tugas yang jatuh di hari ini<br>2. Buka **Grouped Tasks Today** | Tampil state kosong (e.g. "Belum ada tugas") tanpa error | ☐ | ☐ |
| O4.3 | Tap tugas dari grouped today ke detail | 1. Dari **Grouped Tasks Today**, tap satu tugas<br>2. Perhatikan navigasi | Masuk ke **Detail Tugas** untuk tugas yang dipilih | ☐ | ☐ |

### 1.5 Tambah Tugas (jika ada UI-nya)

| ID | Skenario | Langkah | Hasil yang Diharapkan | Pass | Fail |
|----|----------|---------|------------------------|------|------|
| O5.1 | Insert tugas baru (online) | 1. Online<br>2. Gunakan alur tambah tugas (jika ada di app: form create task)<br>3. Isi judul, tanggal, level, priority, acceptance criteria, user_id<br>4. Submit | Tugas tersimpan ke server, snackbar sukses (jika ada), daftar tugas ter-refresh dan tugas baru muncul di list | ☐ | ☐ |

*Catatan: Jika tidak ada form tambah tugas di UI, skenario ini bisa di-skip atau dilakukan lewat integrasi (API/ Supabase) untuk memastikan flow insert di repository.*

### 1.6 Update Tugas (jika ada UI-nya)

| ID | Skenario | Langkah | Hasil yang Diharapkan | Pass | Fail |
|----|----------|---------|------------------------|------|------|
| O6.1 | Update data tugas (online) | 1. Online<br>2. Buka detail suatu tugas<br>3. Ubah data (jika ada tombol/edit) dan simpan | Data ter-update di server, tampilan ter-update, tanpa error | ☐ | ☐ |

### 1.7 Update Status Tugas (jika ada UI-nya)

| ID | Skenario | Langkah | Hasil yang Diharapkan | Pass | Fail |
|----|----------|---------|------------------------|------|------|
| O7.1 | Ubah status jadi on_progress / finished | 1. Online<br>2. Buka detail tugas dengan status **todo**<br>3. Ubah status ke **on_progress** atau **finished** (jika ada kontrol di UI) | Status tersimpan ke server, setelah refresh/kembali ke list status tampil sesuai | ☐ | ☐ |

### 1.8 Hapus Tugas (jika ada UI-nya)

| ID | Skenario | Langkah | Hasil yang Diharapkan | Pass | Fail |
|----|----------|---------|------------------------|------|------|
| O8.1 | Hapus tugas (online) | 1. Online<br>2. Hapus satu tugas (dari list atau detail, jika ada tombol hapus)<br>3. Konfirmasi jika ada | Snackbar "Tugas berhasil dihapus", tugas hilang dari list | ☐ | ☐ |

---

## 2. Mode OFFLINE

### 2.1 Menampilkan Data dari Cache (Setelah Pernah Online)

| ID | Skenario | Langkah | Hasil yang Diharapkan | Pass | Fail |
|----|----------|---------|------------------------|------|------|
| F1.1 | Buka list tugas saat offline (data sudah pernah di-sync) | 1. **Online**: Buka **Tugas HRD**, pastikan daftar tugas tampil (supaya tersimpan ke lokal)<br>2. **Offline**: Aktifkan airplane mode / matikan Wi‑Fi & data<br>3. Buka lagi **Tugas HRD** (atau refresh) | Daftar tugas tetap tampil dari **cache lokal** (data terakhir yang di-sync). Tidak crash. Boleh ada indikator "offline" jika ada. | ☐ | ☐ |
| F1.2 | Buka detail tugas saat offline | 1. Dalam kondisi offline (setelah F1.1)<br>2. Tap salah satu tugas di list | **Detail Tugas** tampil dengan data yang sama seperti saat terakhir di-sync | ☐ | ☐ |
| F1.3 | Rekap di homepage saat offline | 1. Offline (setelah pernah sync)<br>2. Buka **Homepage HRD** | Kartu rekap tugas menampilkan angka berdasarkan **data cache** (tugas hari ini, overdue, selesai, todo, on progress) | ☐ | ☐ |
| F1.4 | Grouped Tasks Today saat offline | 1. Offline (setelah pernah sync)<br>2. Buka **Grouped Tasks Today** | Tugas hari ini (dari cache) tampil dikelompokkan per user, tanpa error | ☐ | ☐ |

### 2.2 Offline – Pertama Kali (Belum Pernah Sync)

| ID | Skenario | Langkah | Hasil yang Diharapkan | Pass | Fail |
|----|----------|---------|------------------------|------|------|
| F2.1 | Buka Tugas HRD tanpa pernah sync | 1. **Offline** dari awal (atau clear data app lalu offline)<br>2. Login HRD<br>3. Buka **Tugas HRD** | Tampil state kosong ("Belum ada tugas") atau list kosong, **tanpa crash**. Tidak ada error yang mengganggu. | ☐ | ☐ |

### 2.3 Offline – Operasi yang Memerlukan Server

*Saat ini, insert/update/delete/updateStatus di repository memanggil Supabase langsung. Saat offline, operasi ini diperkirakan gagal.*

| ID | Skenario | Langkah | Hasil yang Diharapkan | Pass | Fail |
|----|----------|---------|------------------------|------|------|
| F3.1 | Tambah tugas saat offline (jika ada UI) | 1. Offline<br>2. Coba tambah tugas baru lewat UI | Pesan error yang jelas (e.g. "Gagal menambahkan tugas" / gagal koneksi), app tidak crash | ☐ | ☐ |
| F3.2 | Update tugas saat offline (jika ada UI) | 1. Offline<br>2. Coba ubah tugas (jika ada aksi edit) | Pesan error yang jelas, app tidak crash | ☐ | ☐ |
| F3.3 | Hapus tugas saat offline (jika ada UI) | 1. Offline<br>2. Coba hapus tugas | Pesan error (e.g. "Gagal menghapus tugas"), app tidak crash | ☐ | ☐ |
| F3.4 | Update status tugas saat offline (jika ada UI) | 1. Offline<br>2. Coba ubah status tugas | Operasi gagal dengan pesan/feedback yang sesuai, app tidak crash | ☐ | ☐ |

### 2.4 Kembali Online Setelah Offline

| ID | Skenario | Langkah | Hasil yang Diharapkan | Pass | Fail |
|----|----------|---------|------------------------|------|------|
| F4.1 | Refresh data setelah kembali online | 1. Setelah sebelumnya melihat list dalam mode offline<br>2. Nyalakan kembali koneksi (online)<br>3. Buka **Tugas HRD** lagi atau trigger refresh | Data diambil lagi dari server dan list ter-update (sync dari Supabase ke lokal) | ☐ | ☐ |

---

## 3. Edge Cases & Validasi

| ID | Skenario | Langkah | Hasil yang Diharapkan | Pass | Fail |
|----|----------|---------|------------------------|------|------|
| E1 | Tugas tanpa assigned user (userName null) | 1. Pastikan ada tugas yang **user_id** ada tapi **users.name** null / tidak di-join<br>2. Buka list & detail | List/detail tampil tanpa crash; "Assigned To" bisa kosong atau "Unknown User" | ☐ | ☐ |
| E2 | Tugas overdue | 1. Pastikan ada tugas dengan **end_date < hari ini** dan status bukan **finished**<br>2. Buka list & homepage | Tugas tampil; hitungan **overdue** di rekap benar | ☐ | ☐ |
| E3 | Tanggal tugas (timezone / format) | 1. Buka detail tugas, perhatikan format tanggal (mulai & selesai) | Format konsisten (e.g. dd-MM-yyyy) dan sesuai data | ☐ | ☐ |
| E4 | Loading state | 1. Online, buka **Tugas HRD** dengan koneksi agak lambat<br>2. Perhatikan saat fetch | Loading indicator tampil saat mengambil data, lalu hilang setelah data tampil atau gagal | ☐ | ☐ |
| E5 | Error dari server (e.g. 500 / timeout) | 1. Simulasi server error atau putus koneksi saat fetch (e.g. matikan WiFi di tengah load)<br>2. Buka **Tugas HRD** | Snackbar/feedback error (e.g. "Gagal mengambil data tugas"), fallback ke data lokal jika ada; tidak crash | ☐ | ☐ |

---

## Ringkasan

- **Total skenario:** 28 (tanpa menghitung sub-step O3.3).
- **Selesai:** _ isi jumlah Pass _
- **Gagal:** _ isi jumlah Fail _
- **Skipped (tidak ada UI):** _ isi jika ada _

**Tanggal test:** ________________  
**Tester:** ________________  
**Device/OS:** ________________  
**Build/Version app:** ________________  

---

*Dokumen ini mengacu pada fitur HRD Tasks di `lib/features/hrd/tasks/` (controller, repository, views) dengan dukungan fetch online + cache lokal (Drift) dan operasi mutasi (insert/update/delete/updateStatus) ke Supabase saat online.*

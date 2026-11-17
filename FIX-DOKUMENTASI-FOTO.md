# Perbaikan dokumentasi foto SYAMA

## Yang diperbaiki
- Foto dokumentasi dikompres di browser sebelum diunggah: WebP, sisi terpanjang maksimal 1600 px, kualitas 80%.
- Upload foto transaksi baru, foto saat edit transaksi, dan penambahan foto dari menu Dokumentasi menggunakan hasil kompresi.
- Foto asli yang dipilih tidak dikirim ke Supabase; yang diunggah adalah file WebP hasil kompresi.
- Bucket `incoming-evidence` disiapkan sebagai private dengan batas file 10 MB dan policy akses sesuai role ADMIN/ATASAN.
- Database hanya menyimpan metadata dan storage path, sedangkan file foto disimpan di Supabase Storage.

## Langkah wajib di Supabase
1. Buka Supabase Dashboard > SQL Editor.
2. Buka file `supabase/migrations/202611170001_fix_documentation_storage.sql`.
3. Salin seluruh isinya ke SQL Editor dan klik Run.
4. Pastikan muncul `Success. No rows returned`.
5. Deploy source project ini ke Vercel, lalu uji unggah foto dari Barang Masuk.

## Catatan
- Batas foto sumber di website adalah 20 MB per foto sebelum kompresi.
- Hasil kompresi menggunakan format WebP dan target dimensi maksimal 1600 px. Ukuran akhir bergantung pada isi foto, tetapi dibatasi oleh limit Storage 10 MB.
- Foto yang sudah pernah gagal diunggah tidak otomatis muncul; unggah ulang dari transaksi terkait.
- File `.env.local`, `node_modules`, dan `dist` tidak disertakan dalam ZIP demi keamanan dan ukuran. Pertahankan `.env.local` milik Anda saat mengganti source.

-- SYAMA: tambah kategori master barang dan izinkan nama sama untuk entri berbeda.
-- Tidak menambah/menghapus tabel atau kolom. Jalankan sekali pada database aktif.
ALTER TYPE public.item_category ADD VALUE IF NOT EXISTS 'SANITARY';
ALTER TYPE public.item_category ADD VALUE IF NOT EXISTS 'MATERIAL_MEP';

-- Nama barang boleh sama jika merupakan entri terpisah dengan kode berbeda.
DROP INDEX IF EXISTS public.items_name_normalized_uidx;

-- Pertahankan ejaan satuan dari daftar gudang (contoh: pcs, pack, RIT).
CREATE OR REPLACE FUNCTION public.sync_item_active_from_unit()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  NEW.unit := NULLIF(BTRIM(COALESCE(NEW.unit, '')), '');
  NEW.is_active := NEW.unit IS NOT NULL;
  RETURN NEW;
END;
$$;

COMMENT ON TYPE public.item_category IS 'Kategori barang SYAMA: MATERIAL, ALAT, SANITARY, MATERIAL_MEP';

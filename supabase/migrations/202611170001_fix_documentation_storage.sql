-- SYAMA: pastikan bucket dokumentasi tersedia dan menerima foto hasil kompresi WebP.
-- Aman dijalankan berulang kali; tidak menghapus file atau metadata dokumentasi yang sudah ada.

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'incoming-evidence',
  'incoming-evidence',
  false,
  10485760,
  ARRAY['image/jpeg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO UPDATE
SET
  public = false,
  file_size_limit = 10485760,
  allowed_mime_types = ARRAY['image/jpeg', 'image/png', 'image/webp'];

-- Pastikan policy sesuai dengan bucket private dan role aplikasi SYAMA.
DROP POLICY IF EXISTS "incoming photo read auth" ON storage.objects;
CREATE POLICY "incoming photo read auth"
ON storage.objects FOR SELECT TO authenticated
USING (bucket_id = 'incoming-evidence');

DROP POLICY IF EXISTS "incoming photo admin insert" ON storage.objects;
CREATE POLICY "incoming photo admin insert"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (bucket_id = 'incoming-evidence' AND public.is_admin());

DROP POLICY IF EXISTS "incoming photo admin update" ON storage.objects;
CREATE POLICY "incoming photo admin update"
ON storage.objects FOR UPDATE TO authenticated
USING (bucket_id = 'incoming-evidence' AND public.is_admin())
WITH CHECK (bucket_id = 'incoming-evidence' AND public.is_admin());

DROP POLICY IF EXISTS "incoming photo admin delete" ON storage.objects;
CREATE POLICY "incoming photo admin delete"
ON storage.objects FOR DELETE TO authenticated
USING (bucket_id = 'incoming-evidence' AND public.is_admin());

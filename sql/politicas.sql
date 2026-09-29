-- ============================================
-- ApuntesU — Tus políticas RLS
-- ============================================

-- ── TICKET 1 — Activar el candado + ver solo lo tuyo ──────────

-- 1a. Activar RLS
ALTER TABLE apuntes ENABLE ROW LEVEL SECURITY;

-- 1b. Cada usuario ve solamente sus propios apuntes
CREATE POLICY "alumno_ve_sus_apuntes"
ON apuntes
FOR SELECT
USING (autor_id = auth.uid());


-- ── TICKET 2 — Insertar solo a tu propio nombre ───────────────

CREATE POLICY "alumno_inserta_sus_apuntes"
ON apuntes
FOR INSERT
WITH CHECK (autor_id = auth.uid());


-- ── TICKET 3 — Editar solo lo tuyo ────────────────────────────

CREATE POLICY "alumno_edita_sus_apuntes"
ON apuntes
FOR UPDATE
USING (autor_id = auth.uid())
WITH CHECK (autor_id = auth.uid());


-- ── BONUS — El monitor ve toda su materia ─────────────────────

CREATE POLICY "monitor_ve_apuntes_de_su_materia"
ON apuntes
FOR SELECT
USING (
    EXISTS (
        SELECT 1
        FROM perfiles
        WHERE perfiles.id = auth.uid()
        AND perfiles.rol = 'monitor'
        AND perfiles.materia_id = apuntes.materia_id
    )
);
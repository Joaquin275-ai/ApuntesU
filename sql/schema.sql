-- ============================================
-- ApuntesU — Esquema del Home Challenge (Misión 30)
-- Corre esto COMPLETO en el SQL Editor de tu proyecto de Supabase
-- ANTES de empezar con los tickets. No lo modifiques.
-- ============================================

-- Perfiles: relaciona cada usuario con su rol y su materia.
-- Esta tabla ya viene con su política de seguridad puesta —
-- no la toques, no es parte de los tickets de hoy.
create table perfiles (
    id uuid primary key references auth.users(id),
    nombre text not null,
    rol text not null default 'estudiante', -- 'estudiante' | 'monitor'
    materia_id uuid not null
);

alter table perfiles enable row level security;

create policy "usuarios leen su propio perfil"
on perfiles
for select
using (auth.uid() = id);

-- Apuntes: cada fila es un apunte que un estudiante subió para una materia.
-- OJO: esta tabla se crea SIN RLS a propósito — activarla es tu Ticket 1.
create table apuntes (
    id uuid primary key default gen_random_uuid(),
    autor_id uuid references auth.users(id) not null,
    materia_id uuid not null,
    contenido text not null,
    creado_en timestamp default now()
);

-- ============================================
-- DATOS DE PRUEBA
-- Antes de correr esto: crea los 2 usuarios de prueba en
-- Authentication > Users (ver README, sección "Preparación"),
-- copia sus UUIDs, y reemplázalos abajo.
-- materia_id es el mismo valor fijo para los dos — están en la misma clase.
-- ============================================

insert into perfiles (id, nombre, rol, materia_id) values
('abe63c71-b0ff-4198-9b30-cba94dface01', 'Alumno', 'estudiante', '22222222-2222-2222-2222-222222222222'),
('aaee8a85-02c2-46cb-b4cc-6062d54c6c67', 'Monitor', 'monitor', '22222222-2222-2222-2222-222222222222');

insert into apuntes (autor_id, materia_id, contenido) values
('abe63c71-b0ff-4198-9b30-cba94dface01', '22222222-2222-2222-2222-222222222222', 'Resumen de la clase de RLS: RLS filtra filas por usuario.'),
('aaee8a85-02c2-46cb-b4cc-6062d54c6c67', '22222222-2222-2222-2222-222222222222', 'auth.uid() devuelve el id del usuario autenticado.');

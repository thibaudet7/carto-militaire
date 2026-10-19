-- Table des postes militaires
CREATE TABLE IF NOT EXISTS postes_militaires (
    id SERIAL PRIMARY KEY,
    nom_poste TEXT NOT NULL,
    type_poste TEXT NOT NULL CHECK (type_poste IN ('Brigade', 'Poste')),
    nom_compagnie TEXT NOT NULL,
    geom GEOMETRY(Point, 4326) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Vue avec lat/lng extraits
CREATE OR REPLACE VIEW postes_militaires_view AS
SELECT
    id,
    nom_poste,
    type_poste,
    nom_compagnie,
    ST_Y(geom) AS lat,
    ST_X(geom) AS lng,
    created_at,
    updated_at
FROM postes_militaires;

-- RLS
ALTER TABLE postes_militaires ENABLE ROW LEVEL SECURITY;

-- Lecture publique
CREATE POLICY "postes_militaires_select" ON postes_militaires
    FOR SELECT USING (true);

-- Ecriture publique (pas d'auth admin pour cette app)
CREATE POLICY "postes_militaires_insert" ON postes_militaires
    FOR INSERT WITH CHECK (true);

CREATE POLICY "postes_militaires_update" ON postes_militaires
    FOR UPDATE USING (true);

CREATE POLICY "postes_militaires_delete" ON postes_militaires
    FOR DELETE USING (true);

-- Grants
GRANT SELECT ON postes_militaires_view TO anon, authenticated;
GRANT ALL ON postes_militaires TO anon, authenticated;
GRANT USAGE, SELECT ON SEQUENCE postes_militaires_id_seq TO anon, authenticated;

-- table evaluation //done
ALTER TABLE Evaluation
ADD CONSTRAINT encadrement_note
CHECK (Note BETWEEN 1 and 5);

-- table cours //done
ALTER TABLE Cours 
ADD CONSTRAINT check_dates 
CHECK (DateDebut <= DateFin);

ALTER TABLE Cours
ADD CONSTRAINT check_intitule_not_empty
CHECK (Intitule IS NOT NULL AND TRIM(Intitule) != '');

ALTER TABLE Cours
ADD CONSTRAINT check_intitule_length
CHECK (LENGTH(Intitule) <= 50);

-- talbe Sessions //done
ALTER TABLE "session_direct"
ADD CONSTRAINT check_heures
CHECK (datedebut < datefin);

-- Table Examens //done
ALTER TABLE examen
ADD CONSTRAINT check_contenu_not_empty
CHECK (Contenu IS NOT NULL AND Contenu != '');

-- Table tentative //done
-- Le score obtenu à une tentative est une valeur comprise entre 0 et 100
ALTER TABLE tentative  
ADD CONSTRAINT score
CHECK (Score BETWEEN 0 AND 100);

ALTER TABLE tentative ADD COLUMN Statut_de_reussite TEXT;

ALTER TABLE tentative
ADD CONSTRAINT check_statut_reussite
CHECK (Statut_de_reussite IN ('validé', 'non_validé'));

-- creer une function pour examiner Statut_de_reussite
CREATE OR REPLACE FUNCTION set_statut_de_reussite()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Score >= 40 THEN
        NEW.Statut_de_reussite := 'validé';
    ELSE
        NEW.Statut_de_reussite := 'non_validé';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Créer un trigger
CREATE TRIGGER set_statut_de_reussite_trigger
BEFORE INSERT OR UPDATE ON tentative
FOR EACH ROW
EXECUTE FUNCTION set_statut_de_reussite();



-- Ne peuvent faire de tentative que les étudiants inscrits au cours associé à l'examen
CREATE OR REPLACE FUNCTION check_tentatives_utilisateur_autorise()
RETURNS TRIGGER AS $$
DECLARE
    is_associated INT;
BEGIN
    -- Vérifie si l'association entre Id_Etudiant et Id_Examen existe
    SELECT COUNT(*)
    INTO is_associated
    FROM Utilisateurs u
    JOIN inscriptions_cours ic ON u.Id_Utilisateur = ic.Id_Utilisateur
    JOIN ordrepartie_cours pc ON ic.Id_Cours = pc.Id_Cours
    JOIN examens e ON pc.Id_Partie = e.Id_Cours
    WHERE u.Id_Utilisateur = NEW.Id_Etudiant
    AND e.Id_Cours = NEW.Id_Examen;
    
    -- Si l'association n'existe pas, annuler l'insertion
    IF is_associated = 0 THEN
        RAISE EXCEPTION 'L''étudiant n''est pas inscrit au cours correspondant à cet examen.';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_tentative_utilisateur_autorise
BEFORE INSERT ON "tentative"
FOR EACH ROW
EXECUTE FUNCTION check_tentative_utilisateur_autorise();

-- creer function
CREATE OR REPLACE FUNCTION check_tentative_utilisateur_autorise()
RETURNS TRIGGER AS $$
DECLARE
    is_associated INT;
BEGIN
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;




-- Tout cours doit être segmenté en une partie au moins
ALTER TABLE Cours 
ADD CONSTRAINT check_nb_parties
CHECK (Nombre_de_parties >= 0);

-- Prix Positif
ALTER TABLE Cours 
ADD CONSTRAINT check_Prix CHECK (Prix >= 0);

-- examiner format de mail
ALTER TABLE Utilisateur 
ADD CONSTRAINT chk_Email 
CHECK (Email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

ALTER TABLE Inscription_Cours 
ADD CONSTRAINT fk_Session_Direct_ID FOREIGN KEY (Session_Direct_ID) REFERENCES Session_Direct(ID) ON DELETE CASCADE ON UPDATE CASCADE;

-- Un étudiant ne peut pas s’inscrire à une session si la session est déjà complète.
CREATE OR REPLACE FUNCTION check_maximumplaces_function()
RETURNS TRIGGER AS $$
DECLARE
    used_places INT;
BEGIN
    -- calcule de places occupees
    SELECT COUNT(*) INTO used_places
    FROM session_direct_Utilisateurs
    WHERE session_direct_Id_session_direct = NEW.Id_session_direct;

    -- si des places depasse le maximum, error
    IF NEW.Nombre_de_placesmaximum <= used_places THEN
        RAISE EXCEPTION 'Le nombre maximum de places est inférieur au nombre de places déjà utilisées.';
    END IF;
    
    -- sinon on continue
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_maximumplaces_trigger
BEFORE INSERT ON session_direct
FOR EACH ROW
EXECUTE FUNCTION check_maximumplaces_function();

DROP TRIGGER check_maximumplaces_trigger ON session_direct;



-- Un étudiant ne peut pas s’inscrire à une session si la session est déjà complète.
CREATE OR REPLACE FUNCTION check_placesmaximum()
RETURNS TRIGGER AS $$
DECLARE
    used_places INT;
BEGIN
    -- Calculate the number of places already used for this session
    SELECT COUNT(*) INTO used_places
    FROM session_direct_Utilisateurs
    WHERE session_direct_Id_session_direct = NEW.Id_session_direct;

    -- Check if the maximum number of places is sufficient
    IF NEW.Nombre_de_placesmaximum < used_places THEN
        RAISE EXCEPTION 'Le nombre maximum de places est inférieur au nombre de places déjà utilisées.';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for INSERT
CREATE OR REPLACE FUNCTION check_placesmaximum()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.max_places < (SELECT COUNT(*) FROM session_direct WHERE some_condition) THEN
        RAISE EXCEPTION 'Le nombre maximum de place a été dépassé.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_placesmaximum_update_trigger
BEFORE UPDATE ON session_direct
FOR EACH ROW
EXECUTE FUNCTION check_placesmaximum();

DROP TRIGGER IF EXISTS check_placesmaximum_update_trigger ON session_direct;


-- Trigger for UPDATE
CREATE TRIGGER check_placesmaximum_update_trigger
BEFORE UPDATE ON session_direct
FOR EACH ROW
EXECUTE FUNCTION check_placesmaximum();

DROP TRIGGER IF EXISTS check_placesmaximum_update_trigger ON session_direct;


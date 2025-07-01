CREATE OR REPLACE FUNCTION CalculerMoyenneClasseUE(
    p_Code_UE IN CHAR,         -- Code de l'UE
    p_Annee IN CHAR            -- Année scolaire
) RETURN NUMBER IS
    v_TotalMoyenne NUMBER := 0;    -- Somme des moyennes des étudiants pour l'UE
    v_NbEtudiants NUMBER := 0;     -- Nombre d'étudiants ayant des notes pour l'UE
    v_MoyenneClasseUE NUMBER := 0; -- Moyenne de classe pour l'UE
BEGIN
    -- Parcourir tous les étudiants ayant des notes pour les ECs de cette UE
    FOR etudiant_rec IN (
        SELECT DISTINCT n.Etudiant
        FROM Note n
        JOIN EC ec ON n.EC = ec.Code
        WHERE ec.UE = p_Code_UE
          AND n.Annee = p_Annee
    ) LOOP
        -- Calculer la moyenne de l'UE pour chaque étudiant
        DECLARE
            v_MoyenneUE NUMBER := 0;
        BEGIN
            v_MoyenneUE := CalculerMoyenUE(etudiant_rec.Etudiant, p_Code_UE, p_Annee);
            v_TotalMoyenne := v_TotalMoyenne + v_MoyenneUE;
            v_NbEtudiants := v_NbEtudiants + 1;
        END;
    END LOOP;

    -- Calcul de la moyenne de classe pour l'UE
    IF v_NbEtudiants > 0 THEN
        v_MoyenneClasseUE := v_TotalMoyenne / v_NbEtudiants;
    ELSE
        v_MoyenneClasseUE := 0; -- Aucun étudiant trouvé
    END IF;

    RETURN v_MoyenneClasseUE;
END;
/
SELECT CalculerMoyenneClasseUE('INF111', '2023-2024') AS MoyenneClasseUE FROM DUAL;
SELECT CalculerMoyenneClasseUE('INF112', '2023-2024') AS MoyenneClasseUE FROM DUAL;

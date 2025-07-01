CREATE OR REPLACE FUNCTION CalculerMoyenneSemestre(
    etud IN CHAR,
    s IN CHAR,
    an IN CHAR
) RETURN NUMBER
IS
    moyResultat NUMBER := 0;
    sommeMoyUE NUMBER := 0;
    sommeCoeffUE NUMBER := 0;
BEGIN
    -- Parcours des UEs du semestre donné pour l'étudiant
    FOR ue_rec IN (
        SELECT DISTINCT UE.Code, UE.Coefficient
        FROM UE
        JOIN EC ON UE.Code = EC.UE
        JOIN Note ON EC.Code = Note.EC
        WHERE UE.Semestre = s AND Note.Etudiant = etud AND Note.Annee = an
    ) LOOP
        DECLARE
            sommeMoyEC NUMBER := 0;
            sommeCoeffEC NUMBER := 0;
        BEGIN
            -- Parcours des ECs de chaque UE pour cet étudiant
            FOR ec_rec IN (
                SELECT EC.Coefficient, Note.Moyenne
                FROM EC
                JOIN Note ON EC.Code = Note.EC
                WHERE EC.UE = ue_rec.Code AND Note.Etudiant = etud AND Note.Annee = an
            ) LOOP
                -- Ajouter la moyenne pondérée de l'EC
                sommeMoyEC := sommeMoyEC + (ec_rec.Moyenne * ec_rec.Coefficient);
                sommeCoeffEC := sommeCoeffEC + ec_rec.Coefficient;
            END LOOP;

            -- Calcul de la moyenne pondérée de l'UE
            IF sommeCoeffEC > 0 THEN
                sommeMoyUE := sommeMoyUE + (sommeMoyEC / sommeCoeffEC) * ue_rec.Coefficient;
                sommeCoeffUE := sommeCoeffUE + ue_rec.Coefficient;
            END IF;
        END;
    END LOOP;

    -- Calcul de la moyenne générale pour cet étudiant
    IF sommeCoeffUE > 0 THEN
        moyResultat := ROUND(sommeMoyUE / sommeCoeffUE, 2);
    ELSE
        moyResultat := NULL; -- Aucun calcul possible
    END IF;

    RETURN moyResultat;
END CalculerMoyenneSemestre;
/
SELECT CalculerMoyenneSemestre('20230001','1', '2023-2024') AS MoyenneSemestreEtudiant FROM DUAL;
SELECT CalculerMoyenneSemestre('20230002','1', '2023-2024') AS MoyenneSemestreEtudiant FROM DUAL;
SELECT CalculerMoyenneSemestre('20230003','1', '2023-2024') AS MoyenneSemestreEtudiant FROM DUAL;
SELECT CalculerMoyenneSemestre('20230004','1', '2023-2024') AS MoyenneSemestreEtudiant FROM DUAL;
SELECT CalculerMoyenneSemestre('20230005','1', '2023-2024') AS MoyenneSemestreEtudiant FROM DUAL;

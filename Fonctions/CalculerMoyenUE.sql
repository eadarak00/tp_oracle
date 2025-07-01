CREATE OR REPLACE FUNCTION CalculerMoyenUE (
    p_Matricule IN CHAR,       -- Matricule de l'étudiant
    p_Code_UE IN CHAR,         -- Code de l'UE
    p_Annee IN CHAR            -- Année scolaire
) RETURN NUMBER IS
    v_MoyenneUE NUMBER(4,2) := 0;  -- Moyenne de l'UE
    v_TotalPondere NUMBER := 0;    -- Somme des moyennes pondérées des ECs
    v_TotalCoefficients SMALLINT := 0; -- Somme des coefficients des ECs
BEGIN
    -- Parcourir tous les ECs de l'UE et calculer la moyenne pondérée
    FOR rec IN (
        SELECT n.Moyenne, ec.Coefficient
        FROM Note n
        JOIN EC ec ON n.EC = ec.Code
        WHERE n.Etudiant = p_Matricule
          AND ec.UE = p_Code_UE
          AND n.Annee = p_Annee
    ) LOOP
        -- Ajouter la moyenne pondérée de l'EC
        v_TotalPondere := v_TotalPondere + (rec.Moyenne * rec.Coefficient);
        -- Ajouter le coefficient de l'EC
        v_TotalCoefficients := v_TotalCoefficients + rec.Coefficient;
    END LOOP;

    -- Calculer la moyenne de l'UE
    IF v_TotalCoefficients > 0 THEN
        v_MoyenneUE := v_TotalPondere / v_TotalCoefficients;
    ELSE
        v_MoyenneUE := 0; -- Si aucun EC trouvé, la moyenne est 0
    END IF;

    RETURN v_MoyenneUE;
END;
/
SELECT CalculerMoyenUE('20230001', 'INF111', '2023-2024') AS Moyenne_UE FROM DUAL;
SELECT CalculerMoyenUE('20230002', 'INF111', '2023-2024') AS Moyenne FROM DUAL;
SELECT CalculerMoyenUE('20230003', 'INF111', '2023-2024') AS Moyenne FROM DUAL;
SELECT CalculerMoyenUE('20230004', 'INF111', '2023-2024') AS Moyenne FROM DUAL;
SELECT CalculerMoyenUE('20230005', 'INF111', '2023-2024') AS Moyenne FROM DUAL;
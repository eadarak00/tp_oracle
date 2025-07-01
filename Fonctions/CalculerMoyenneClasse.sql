CREATE OR REPLACE FUNCTION CalculerMoyenneClasse(
    semestre IN CHAR,
    annee IN CHAR
) RETURN NUMBER
IS
    totalEtudiants NUMBER := 0;
    sommeMoyennes NUMBER := 0;
    moyenneClasse NUMBER := 0;
BEGIN
    -- Compter le nombre d'étudiants pour le semestre donné
    SELECT COUNT(*) INTO totalEtudiants
    FROM Resultat
    WHERE Semestre = semestre AND Annee = annee;

    -- Somme de toutes les moyennes pour le semestre donné
    SELECT SUM(Moyenne) INTO sommeMoyennes
    FROM Resultat
    WHERE Semestre = semestre AND Annee = annee;

    -- Calcul de la moyenne de classe
    IF totalEtudiants > 0 THEN
        moyenneClasse := ROUND(sommeMoyennes / totalEtudiants, 2);
    ELSE
        moyenneClasse := NULL; -- Aucun étudiant trouvé
    END IF;

    RETURN moyenneClasse;
END CalculerMoyenneClasse;
/
SELECT CalculerMoyenneClasse('1', '2023-2024') AS MoyenneClasse
FROM DUAL;

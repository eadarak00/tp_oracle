CREATE OR REPLACE FUNCTION CalculerMoyenneClasseEC(
    c IN CHAR
) RETURN NUMBER
IS
    totalEtudiants NUMBER := 0;
    sommeMoyennes NUMBER := 0;
    moyenneClasseEC NUMBER := 0;
BEGIN
    -- Compter le nombre d'étudiants pour l'EC donné
    SELECT COUNT(*) INTO totalEtudiants
    FROM Note n
    WHERE n.EC = c;

    -- Somme de toutes les moyennes pour l'EC donné
    SELECT SUM(Moyenne) INTO sommeMoyennes
    FROM Note n
    WHERE n.EC = c;

    -- Affichages intermédiaires pour débogage
    DBMS_OUTPUT.PUT_LINE('Total Etudiants : ' || totalEtudiants);
    DBMS_OUTPUT.PUT_LINE('Somme Moyennes : ' || sommeMoyennes);

    -- Calcul de la moyenne de classe pour l'EC
    IF totalEtudiants > 0 THEN
        moyenneClasseEC := ROUND(sommeMoyennes / totalEtudiants, 2);
    ELSE
        moyenneClasseEC := NULL; -- Aucun étudiant trouvé
    END IF;

    RETURN moyenneClasseEC;
END CalculerMoyenneClasseEC;
/
 SELECT CalculerMoyenneClasseEC('INF1111') AS MoyenneClasseEC FROM DUAL;

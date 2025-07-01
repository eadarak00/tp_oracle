BEGIN
    -- Suppression des résultats existants
    DELETE FROM Resultat;

    -- Calcul de la moyenne semestrielle
    Calculer_Moyenne_Semestrielle('L1', 1, '2023-2024');

    -- Affichage des résultats de la classe
    -- Afficher_Resultat_Classe('L1', 1, '2023-2024');
    DBMS_OUTPUT.PUT_LINE('                             ');
    DBMS_OUTPUT.PUT_LINE('************************************************');
    -- Affichage des étudiants par ordre de mérite
    Afficher_Etudiant_Merite('L1', 1, '2023-2024');

    DBMS_OUTPUT.PUT_LINE('                             ');
    DBMS_OUTPUT.PUT_LINE('************************************************');
    -- Affichage du relevé de l'étudiant
    Afficher_Relevee('20230003', 'L1', 1, '2023-2024');

    DBMS_OUTPUT.PUT_LINE('                             ');
    DBMS_OUTPUT.PUT_LINE('************************************************');
    --Affichage des UEs validés
    Afficher_UE_Valide('20230001', 'L1', 1, '2023-2024');

    DBMS_OUTPUT.PUT_LINE('                             ');
    DBMS_OUTPUT.PUT_LINE('************************************************');
    --Lister les etudiants
    Lister_Etudiant_Valides( 'L1', 1, '2023-2024');


    DBMS_OUTPUT.PUT_LINE('                             ');
    DBMS_OUTPUT.PUT_LINE('************************************************');
    --Afficher le Majorant
    Afficher_Majorant('L1', 1, '2023-2024');
END;
/

-- SET SERVEROUTPUT ON;
-- ALTER SESSION SET NLS_LANGUAGE = 'FRENCH';
--  ALTER SESSION SET NLS_TERRITORY = 'FRANCE';
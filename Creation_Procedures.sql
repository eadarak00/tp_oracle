-- Fichier contenant les procedures --

DROP PROCEDURE  Calculer_Moyenne_Semestrielle;
DROP PROCEDURE  Afficher_Resultat_Classe;
DROP PROCEDURE  Afficher_Etudiant_Merite;
DROP PROCEDURE  Afficher_Relevee;
DROP PROCEDURE  Afficher_UE_Valide;
DROP PROCEDURE  Lister_Etudiant_Valides;
DROP PROCEDURE  Afficher_Majorant;

/*
 Procedure
 -- Qui calcule la moyenne semestrielle des étudiants d’un niveau donné pour un semestre 
    donné et remplit la table Resultat ;
*/

CREATE OR REPLACE PROCEDURE Calculer_Moyenne_Semestrielle (niv IN CHAR, sem IN CHAR, an IN CHAR) 
AS
    CURSOR cur_etudiants IS
        SELECT DISTINCT Etudiant.Matricule
        FROM Etudiant
        WHERE Etudiant.Niveau = niv
    ;

    moy_ue NUMBER(4, 2);
    moy_sem NUMBER(4, 2);
    som_coefs_UE NUMBER := 0;
    som_moy_UE NUMBER := 0;
    v_rang SMALLINT := 1;
    cy  Semestre.Cycle%TYPE;

BEGIN
    -- Récupérer le cycle du semestre
    SELECT Cycle INTO cy FROM Semestre WHERE Numero = sem AND Annee = an;

    -- Parcourir les étudiants
    FOR etu IN cur_etudiants LOOP
        moy_sem := 0;
        som_coefs_UE := 0;
        som_moy_UE := 0;

        -- Parcourir les UEs pour chaque étudiant
        FOR ues IN 
            (SELECT UE.Code, UE.Coefficient
             FROM UE
             WHERE UE.Semestre = sem AND UE.Cycle = cy) 
        LOOP
            DECLARE
                somme_coefs_EC NUMBER := 0;
                somme_moy_EC NUMBER := 0;

            BEGIN
                -- Parcourir les ECs pour chaque UE
                FOR ecs IN 
                    (SELECT Note.Moyenne, EC.Coefficient
                     FROM Note, EC 
                     WHERE Note.Etudiant = etu.Matricule 
                       AND Note.EC = EC.Code 
                       AND EC.UE = ues.Code) 
                LOOP
                    somme_coefs_EC := somme_coefs_EC + ecs.Coefficient;
                    somme_moy_EC := somme_moy_EC + (ecs.Coefficient * ecs.Moyenne);
                END LOOP;

                -- Calculer la moyenne de l'UE
                IF somme_coefs_EC > 0 THEN
                    moy_ue := somme_moy_EC / somme_coefs_EC;
                ELSE
                    moy_ue := 0;
                END IF;

                som_coefs_UE := som_coefs_UE + ues.Coefficient;
                som_moy_UE := som_moy_UE + (ues.Coefficient * moy_ue);
            END;
        END LOOP;

        -- Calculer la moyenne semestrielle
        IF som_coefs_UE > 0 THEN
            moy_sem := som_moy_UE / som_coefs_UE;
        ELSE
            moy_sem := 0;
        END IF;

        -- Calculer la mention
        DECLARE
            v_mention VARCHAR2(10);
        BEGIN
            IF moy_sem >= 16 THEN
                v_mention := 'Tres Bien';
            ELSIF moy_sem >= 14 THEN
                v_mention := 'Bien';
            ELSIF moy_sem >= 12 THEN
                v_mention := 'Assez Bien';
            ELSIF moy_sem >= 10 THEN
                v_mention := 'Passable';
            ELSE
                v_mention := ' ';
            END IF;

            -- Insérer les résultats dans la table Resultat sans rang
            INSERT INTO Resultat (Etudiant, Semestre, Cycle, Annee, Moyenne, Mention, Rang)
            VALUES (etu.Matricule, sem, cy, an, moy_sem, v_mention, NULL); -- Rang est NULL pour l'instant
        END;
    END LOOP;

    -- Mettre à jour les rangs après l'insertion
    DECLARE
        CURSOR cur_resultats IS
            SELECT Etudiant, Moyenne
            FROM Resultat
            WHERE Semestre = sem AND Annee = an AND Cycle = cy
            ORDER BY Moyenne DESC;
    BEGIN
        -- Initialiser le rang
        v_rang := 1;

        -- Boucle pour attribuer les rangs après l'insertion
        FOR etudiant_rang IN cur_resultats LOOP
            -- Mettre à jour le rang dans la table Resultat
            UPDATE Resultat
            SET Rang = v_rang
            WHERE Etudiant = etudiant_rang.Etudiant
              AND Semestre = sem
              AND Annee = an
              AND Cycle = cy;

            -- Incrémenter le rang pour le prochain étudiant
            v_rang := v_rang + 1;
        END LOOP;

        COMMIT; -- Commit des changements dans la base de données
    END;

END;
/

/*
-- Qui affiche les résultats d’une classe donnée (Niveau) par ordre de mérite pour un semestredonné d’une année donnée ; 
*/

CREATE OR REPLACE PROCEDURE Afficher_Resultat_Classe(niv IN CHAR, sem IN CHAR, an IN CHAR)
AS
 cy  Semestre.Cycle%TYPE;
BEGIN
    SELECT Cycle INTO cy FROM Semestre WHERE Numero = sem AND Annee = an;
    -- Afficher l'en-tête des résultats
    DBMS_OUTPUT.PUT_LINE('Resultats de la classe :');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Année             : ' || an);
    DBMS_OUTPUT.PUT_LINE('Niveau            : ' || cy || ' ' || sem);
    DBMS_OUTPUT.PUT_LINE('Semestre          : Semestre ' || sem);

    -- Afficher les résultats triés par moyenne
    FOR rec IN (
        SELECT Resultat.*
        FROM Resultat, Etudiant WHERE
            Resultat.Etudiant = Etudiant.Matricule
            AND Resultat.Semestre = sem
            AND Resultat.Annee = an
            AND Etudiant.Niveau = niv
    ) LOOP
        -- Afficher les résultats pour chaque étudiant
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        DBMS_OUTPUT.PUT_LINE(rec.Etudiant || '     ' || rec.Moyenne || '     ' || rec.Resultat || '     ' || rec.Rang);
    END LOOP;
END;
/



/*
-- Qui fait le classement par ordre de mérite des étudiants d’une classe pour un semestre  d’une année donnée ;
*/
CREATE OR REPLACE PROCEDURE Afficher_Etudiant_Merite(niv IN CHAR, sem IN CHAR, an IN CHAR)
AS
    cy  Semestre.Cycle%TYPE;
BEGIN
    -- Récupérer le cycle du semestre
    SELECT Cycle INTO cy FROM Semestre WHERE Numero = sem AND Annee = an;

    -- Afficher l'en-tête
    DBMS_OUTPUT.PUT_LINE('=======================================================================');
    DBMS_OUTPUT.PUT_LINE('                  LISTE DES ÉTUDIANTS PAR ORDRE DE MÉRITE              ');
    DBMS_OUTPUT.PUT_LINE('=======================================================================');
    DBMS_OUTPUT.PUT_LINE('Année    : ' || an);
    DBMS_OUTPUT.PUT_LINE('Niveau   : ' || cy || ' ' || sem);
    DBMS_OUTPUT.PUT_LINE('Semestre : Semestre ' || sem);
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(RPAD('MATRICULE', 12) || RPAD('NOM', 15) || RPAD('PRÉNOM', 15) || 
                         RPAD('MOYENNE', 10) || RPAD('MENTION', 12) || 'RANG');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------');

    -- Sélectionner les étudiants avec leurs résultats, triés par ordre de mérite
    FOR rec IN (
        SELECT Etudiant.Matricule, Etudiant.Nom, Etudiant.Prenom, Resultat.Moyenne, 
               Resultat.Mention, Resultat.Rang
        FROM Etudiant
        JOIN Resultat ON Etudiant.Matricule = Resultat.Etudiant
        WHERE Etudiant.Niveau = niv
          AND Resultat.Semestre = sem
          AND Resultat.Annee = an
        ORDER BY Resultat.Rang
    ) LOOP
        -- Affichage formaté avec alignement constant
        DBMS_OUTPUT.PUT_LINE(RPAD(rec.Matricule, 12) || RPAD(rec.Nom, 15) || RPAD(rec.Prenom, 15) ||
                             RPAD(TO_CHAR(rec.Moyenne, '99.99'), 10) || RPAD(rec.Mention, 12) ||
                             TO_CHAR(rec.Rang));
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('=======================================================================');
END;
/


/*
-- Qui affiche le relevé d’un étudiant donné pour un semestre donné ; 
*/
CREATE OR REPLACE PROCEDURE Afficher_Relevee(    
    num_carte IN CHAR, 
    niv IN CHAR, 
    sem IN CHAR, 
    an IN CHAR)
AS
    nom_etudiant Etudiant.Nom%TYPE;
    prenom_etudiant Etudiant.Prenom%TYPE;
    age_etudiant Etudiant.Age%TYPE;
    sexe_etudiant Etudiant.Sexe%TYPE;
    moyenne_etudiant Resultat.Moyenne%TYPE;
    rang_etudiant Resultat.Rang%TYPE;
    credits NUMBER := 0;
    mention_etudiant Resultat.Mention%TYPE;
    decision Resultat.Resultat%TYPE;
    
    -- Exception pour gérer les étudiants non trouvés
    student_not_found EXCEPTION;
    result_not_found EXCEPTION;
    cy  Semestre.Cycle%TYPE;
BEGIN
    -- Récupérer les informations de l'étudiant
    BEGIN
        SELECT Nom, Prenom, Age, Sexe
        INTO nom_etudiant, prenom_etudiant, age_etudiant, sexe_etudiant
        FROM Etudiant
        WHERE Matricule = num_carte;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE student_not_found;
    END;

    -- Récupérer le cycle du semestre
    SELECT Cycle INTO cy FROM Semestre WHERE Numero = sem AND Annee = an;

    -- Afficher l'en-tête du relevé
    DBMS_OUTPUT.PUT_LINE('================================================================================');
    DBMS_OUTPUT.PUT_LINE('                            RELEVÉ DE NOTES                                     ');
    DBMS_OUTPUT.PUT_LINE('================================================================================');
    DBMS_OUTPUT.PUT_LINE('Année    : ' || an);
    DBMS_OUTPUT.PUT_LINE('Niveau   : ' || cy || ' ' || sem);
    DBMS_OUTPUT.PUT_LINE('Semestre : Semestre ' || sem);
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Numéro de carte  : ' || num_carte);
    DBMS_OUTPUT.PUT_LINE('Nom et Prénom    : ' || nom_etudiant || ' ' || prenom_etudiant);
    DBMS_OUTPUT.PUT_LINE('Âge              : ' || age_etudiant || ' ans');
    DBMS_OUTPUT.PUT_LINE('Sexe              : ' || sexe_etudiant);
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(RPAD('Code EC', 10) || RPAD('Libellé', 25) || RPAD('CC', 10) || RPAD('Examen', 10) || RPAD('Moyenne', 10));
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');

    -- Affichage des résultats par matière
    FOR rec IN (
        SELECT EC.Code AS Code_EC, EC.Libelle AS Libelle_EC, 
               Note.Moyenne AS Moyenne_EC, Note.Controle AS CC, Note.Examen AS Exam, 
               EC.Credit AS Credit_EC
        FROM Note
        JOIN EC ON Note.EC = EC.Code
        JOIN UE ON EC.UE = UE.Code
        JOIN Etudiant ON Note.Etudiant = Etudiant.Matricule
        WHERE UE.Semestre = sem
          AND Etudiant.Niveau = niv
          AND Note.Annee = an
          AND Note.Etudiant = num_carte
        ORDER BY EC.Code
    ) LOOP
        -- Affichage formaté pour chaque matière
        DBMS_OUTPUT.PUT_LINE(RPAD(rec.Code_EC, 10) || RPAD(rec.Libelle_EC, 25) || 
                             RPAD(TO_CHAR(rec.CC, '99.99'), 10) || RPAD(TO_CHAR(rec.Exam, '99.99'), 10) || 
                             RPAD(TO_CHAR(rec.Moyenne_EC, '99.99'), 10));

        -- Ajouter les crédits si la moyenne d'un EC est supérieure ou égale à 10
        IF rec.Moyenne_EC >= 10 THEN
            credits := credits + rec.Credit_EC;
        END IF;
    END LOOP;

    -- Récupérer les résultats globaux de l'étudiant
    BEGIN
        SELECT Moyenne, Resultat, Mention, Rang
        INTO moyenne_etudiant, decision, mention_etudiant, rang_etudiant
        FROM Resultat
        WHERE Etudiant = num_carte
          AND Semestre = sem
          AND Annee = an;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE result_not_found;
    END;

    -- Afficher les résultats globaux
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Moyenne générale  : ' || moyenne_etudiant);
    DBMS_OUTPUT.PUT_LINE('Crédits obtenus    : ' || credits);
    DBMS_OUTPUT.PUT_LINE('Décision du jury   : ' || decision);
    DBMS_OUTPUT.PUT_LINE('Mention             : ' || mention_etudiant);
    DBMS_OUTPUT.PUT_LINE('Rang                : ' || rang_etudiant);
    DBMS_OUTPUT.PUT_LINE('================================================================================');

EXCEPTION
    WHEN student_not_found THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : Aucun étudiant trouvé avec le numéro de carte ' || num_carte);
    WHEN result_not_found THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : Aucun résultat trouvé pour cet étudiant au semestre ' || sem || ' de l''année ' || an);
END;
/


/*
--   affiche la liste des EC validés par un étudiant donné pour un semestre donné
*/
CREATE OR REPLACE PROCEDURE Afficher_UE_Valide(    
    num_carte IN CHAR, 
    niv IN CHAR, 
    sem IN CHAR, 
    an IN CHAR
)
AS
    -- Déclaration des variables pour stocker les informations de l'étudiant
    nom_etudiant Etudiant.Nom%TYPE;
    prenom_etudiant Etudiant.Prenom%TYPE;
    age_etudiant Etudiant.Age%TYPE;
    sexe_etudiant Etudiant.Sexe%TYPE;
    
    -- Exception personnalisée si l'étudiant n'existe pas
    student_not_found EXCEPTION;
    
    -- Vérificateur pour savoir si au moins une ligne a été affichée
    aucun_ec_valide BOOLEAN := TRUE; 
BEGIN
    -- Vérification de l'existence de l'étudiant
    BEGIN
        SELECT Nom, Prenom, Age, Sexe
        INTO nom_etudiant, prenom_etudiant, age_etudiant, sexe_etudiant
        FROM Etudiant
        WHERE Matricule = num_carte;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : Aucun étudiant trouvé avec ce numéro de carte.');
            RAISE student_not_found;
    END;

    -- Affichage de l'entête
    DBMS_OUTPUT.PUT_LINE('================================================================================');
    DBMS_OUTPUT.PUT_LINE('                          LISTE DES EC VALIDÉS                                  ');
    DBMS_OUTPUT.PUT_LINE('================================================================================');
    
    -- Afficher les en-têtes des colonnes
    DBMS_OUTPUT.PUT_LINE(
        RPAD('Code_EC', 10) || RPAD('Libellé_EC', 30) || RPAD('Coef', 5) ||
        RPAD('Crédits', 8) || RPAD('CC', 6) || RPAD('Exam', 6) || RPAD('Moyenne', 8)
    );
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------');

    -- Affichage des résultats par matière (uniquement les EC validés)
    FOR rec IN (
        SELECT EC.Code AS Code_EC, EC.Libelle AS Libelle_EC,  
               Note.Moyenne AS Moyenne_EC, Note.Controle AS CC, Note.Examen AS Exam, 
               EC.Credit AS Credit_EC, EC.Coefficient AS Coefficient_EC
        FROM Note
        JOIN EC ON Note.EC = EC.Code
        JOIN UE ON EC.UE = UE.Code
        JOIN Etudiant ON Note.Etudiant = Etudiant.Matricule
        WHERE UE.Semestre = sem
          AND Etudiant.Niveau = niv
          AND Note.Annee = an
          AND Note.Etudiant = num_carte
          AND Note.Moyenne >= 10  -- Filtrer directement en SQL
        ORDER BY EC.Code
    ) LOOP
        -- Indiquer qu'au moins une ligne a été trouvée
        aucun_ec_valide := FALSE;

        -- Affichage formaté des données
        DBMS_OUTPUT.PUT_LINE(
            RPAD(rec.Code_EC, 10) || RPAD(rec.Libelle_EC, 30) || RPAD(rec.Coefficient_EC, 5) ||
            RPAD(rec.Credit_EC, 8) || RPAD(rec.CC, 6) || RPAD(rec.Exam, 6) || RPAD(rec.Moyenne_EC, 8)
        );
    END LOOP;

    -- Si aucun EC n'a été validé
    IF aucun_ec_valide THEN
        DBMS_OUTPUT.PUT_LINE('Aucun EC validé pour cet étudiant.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------');

EXCEPTION
    WHEN student_not_found THEN
        -- Gestion de l'exception si l'étudiant n'existe pas
        DBMS_OUTPUT.PUT_LINE('Procédure interrompue : Étudiant introuvable.');
    WHEN OTHERS THEN
        -- Gestion de toute autre erreur
        DBMS_OUTPUT.PUT_LINE('Erreur inattendue : ' || SQLERRM);
END;
/


/*
-- Liste des etudiants validés
*/
CREATE OR REPLACE PROCEDURE Lister_Etudiant_Valides(
    niv IN CHAR, 
    sem IN CHAR, 
    an IN CHAR
)
AS
BEGIN
      DBMS_OUTPUT.PUT_LINE('================================================================================');
    DBMS_OUTPUT.PUT_LINE('                          LISTE ETUDIANTS VALIDÉS                                  ');
    DBMS_OUTPUT.PUT_LINE('================================================================================');
    
    DBMS_OUTPUT.PUT_LINE(
        RPAD('Matricule', 12) || RPAD('Prénom', 15) || RPAD('Nom', 15) || 
        RPAD('Âge', 5) || RPAD('Sexe', 8) || RPAD('Moyenne', 10) || RPAD('Mention', 15)
    );
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');

    -- Affichage des étudiants qui ont validé le semestre
    FOR rec IN (
        SELECT Etudiant.Matricule AS mat, Etudiant.Prenom AS p, Etudiant.Nom AS n, 
               Etudiant.Age AS ag, Etudiant.Sexe AS s, 
               Resultat.Moyenne AS m, Resultat.Mention AS men
        FROM Etudiant 
        JOIN Resultat ON Etudiant.Matricule = Resultat.Etudiant
        WHERE Etudiant.Niveau = niv
          AND Resultat.Semestre = sem
          AND Resultat.Annee = an
          AND Resultat.Moyenne >= 10  
        ORDER BY Matricule
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(rec.mat, 12) || RPAD(rec.p, 15) || RPAD(rec.n, 15) || 
            RPAD(rec.ag, 5) || RPAD(rec.s, 8) || RPAD(TO_CHAR(rec.m, '99.99'), 10) || RPAD(rec.men, 15)
        );
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');
END;
/


/*
--   Qui donne le major d’une classe donnée pour un semestre donné
*/
CREATE OR REPLACE PROCEDURE Afficher_Majorant(
    niv IN CHAR, 
    sem IN CHAR, 
    an IN CHAR
)
AS
    mat_etu     Etudiant.Matricule%TYPE;
    nom_etu     Etudiant.Nom%TYPE;
    prenom_etu  Etudiant.Prenom%TYPE;
    age_etu     Etudiant.Age%TYPE;
    sexe_etu    Etudiant.Sexe%TYPE;

    student_not_found EXCEPTION; -- Exception pour gérer le cas où aucun major n'est trouvé

BEGIN
    DBMS_OUTPUT.PUT_LINE('================================================================================');
    DBMS_OUTPUT.PUT_LINE('                              LE MAJORANT DE LA CLASSE                           ');
    DBMS_OUTPUT.PUT_LINE('================================================================================');
    
    BEGIN
        -- Sélection du major
        SELECT Etudiant.Matricule, Etudiant.Nom, Etudiant.Prenom, Etudiant.Age, Etudiant.Sexe
        INTO mat_etu, nom_etu, prenom_etu, age_etu, sexe_etu
        FROM Etudiant 
        JOIN Resultat ON Etudiant.Matricule = Resultat.Etudiant
        WHERE Etudiant.Niveau = niv 
          AND Resultat.Semestre = sem 
          AND Resultat.Annee = an 
          AND Resultat.Rang = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE student_not_found; -- Si aucun major n'est trouvé
    END;

    -- Affichage des informations du major
    DBMS_OUTPUT.PUT_LINE(
        RPAD(mat_etu, 10) || RPAD(nom_etu, 20) || RPAD(prenom_etu, 20) || 
        RPAD(age_etu, 5) || RPAD(sexe_etu, 8)
    );

EXCEPTION
    WHEN student_not_found THEN
        DBMS_OUTPUT.PUT_LINE('Aucun étudiant major n''a été trouvé pour ce semestre.');
END;
/

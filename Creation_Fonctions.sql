/* == Fichier de creation de fonction == */


/**
 * Fonction : CalculerMoyenneUeEtudiant
 * Description : Calcule la moyenne pondérée d'un étudiant pour une UE donnée sur une année d'une semestre donnée
 * 
 * Paramètres :
 *   - p_Matricule (CHAR) : Matricule de l'étudiant
 *   - p_codeUE (CHAR) : Code de l'Unité d'Enseignement
 *   - p_annee (CHAR) : Année scolaire (format AAAA-AAAA)
 *   - p_Semestre (CHAR) : Semestre (1)
 * 
 * Retour :
 *   - NUMBER(4,2) : Moyenne pondérée de l'UE (entre 0 et 20 avec 2 décimales)
 * 
 */
CREATE OR REPLACE FUNCTION CalculerMoyenneUeEtudiant (
    p_Matricule IN CHAR,      
    p_codeUE IN CHAR,        
    p_annee IN CHAR,           
    p_Semestre IN CHAR          
) RETURN NUMBER IS
    v_MoyenneUE NUMBER(4,2) := 0;
    v_TotalPondere NUMBER := 0;   
    v_TotalCoefficients SMALLINT := 0;
BEGIN
    -- Parcourir tous les ECs de l'UE et calculer la moyenne pondérée
    FOR rec IN (
        SELECT n.Moyenne, ec.Coefficient
        FROM Note n
        JOIN EC ec ON n.EC = ec.Code
        JOIN UE ue ON ec.UE = ue.Code
        WHERE n.Etudiant = p_Matricule
          AND ue.Code = p_codeUE
          AND ec.UE = p_codeUE
          AND n.Annee = p_annee
          AND ue.Semestre = p_Semestre
    ) LOOP
        v_TotalPondere := v_TotalPondere + (rec.Moyenne * rec.Coefficient);
        v_TotalCoefficients := v_TotalCoefficients + rec.Coefficient;
    END LOOP;

    IF v_TotalCoefficients > 0 THEN
        v_MoyenneUE := v_TotalPondere / v_TotalCoefficients;
    ELSE
        v_MoyenneUE := 0;
    END IF;

    RETURN v_MoyenneUE;
END;
/

/**
 * FONCTION : CalculerMoyenneSemestreEtudiant
 * 
 * Description : 
 *   Calcule la moyenne pondérée d'un étudiant pour un semestre donné en parcourant
 *   toutes ses UEs et leurs ECs associés.
 * 
 * Paramètres :
 *   - etud (CHAR) : Matricule de l'étudiant
 *   - s (CHAR)    : Code du semestre (ex: '1')
 *   - an (CHAR)   : Année scolaire (ex: '2023-2024')
 * 
 * Retour :
 *   - NUMBER : Moyenne semestrielle pondérée (arrondie à 2 décimales)
 *              NULL si aucune note trouvée
 * 
 * Logique de calcul :
 *   1. Parcourt toutes les UEs du semestre pour l'étudiant
 *   2. Pour chaque UE :
 *      a) Calcule la moyenne pondérée des ECs
 *      b) Pondère cette moyenne par le coefficient de l'UE
 *   3. Calcule la moyenne générale en divisant la somme pondérée
 *      des moyennes d'UE par la somme des coefficients
 * 
 * Tables utilisées :
 *   - UE : Contient les coefficients des UEs et leur rattachement aux semestres
 *   - EC : Contient les coefficients des ECs et leur rattachement aux UEs
 *   - Note : Contient les moyennes des étudiants par EC
 * 
 * Gestion des erreurs :
 *   - Retourne NULL si aucune note n'est trouvée
 *   - Gère automatiquement les divisions par zéro
 * 
 */
CREATE OR REPLACE FUNCTION CalcMoyenneSemestreEtudiant(
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
END CalcMoyenneSemestreEtudiant;
/

/**
 * FONCTION : CalcMoyenneClasseSemestre
 * 
 * Description :
 *   Calcule la moyenne générale d'une classe pour un semestre donné en agrégeant
 *   les moyennes individuelles des étudiants stockées dans la table Resultat.
 * 
 * Paramètres :
 *   - semestre (CHAR) : Code du semestre (ex: '1', '2')
 *   - annee (CHAR)    : Année académique (ex: '2023-2024')
 * 
 * Retour :
 *   - NUMBER : Moyenne de la classe arrondie à 2 décimales
 *              NULL si aucun étudiant trouvé
 * 
 * Logique de calcul :
 *   1. Compte le nombre d'étudiants ayant des résultats pour le semestre
 *   2. Fait la somme de toutes leurs moyennes semestrielles
 *   3. Calcule la moyenne générale (somme des moyennes / nombre d'étudiants)
 * 
 * Tables utilisées :
 *   - Resultat : Doit contenir les colonnes Semestre, Annee et Moyenne
 * 
 * Gestion des erreurs :
 *   - Retourne NULL si aucun étudiant n'a de résultat pour le semestre
 *   - Gère automatiquement la division par zéro
 * 
 * Exemple d'appel :
 *   SELECT CalcMoyenneClasseSemestre('1', '2023-2024') FROM dual;
 * 
 * Notes :
 *   - La table Resultat doit être préalablement remplie par la procédure Calculer_Moyenne_Semestrielle
 *   - Les moyennes individuelles doivent être calculées avant d'appeler cette fonction
 * 
*/
CREATE OR REPLACE FUNCTION CalcMoyenneClasseSemestre(
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
END CalcMoyenneClasseSemestre;
/

/**
 * FONCTION : CalculerMoyenneClasseEC
 * 
 * Description :
 *   Calcule la moyenne d'une classe pour un Élément Constitutif (EC) donné
 *   à partir des notes des étudiants dans la table Note.
 * 
 * Paramètres :
 *   - c (CHAR) : Code de l'EC (ex: 'INF101', 'MAT202')
 * 
 * Retour :
 *   - NUMBER : Moyenne de la classe pour l'EC (arrondie à 2 décimales)
 *              NULL si aucun étudiant n'a de note pour cet EC
 * 
 * Logique de calcul :
 *   1. Compte le nombre d'étudiants ayant une note pour l'EC
 *   2. Fait la somme de toutes les moyennes pour cet EC
 *   3. Calcule la moyenne générale (somme des moyennes / nombre d'étudiants)
 * 
 * Tables utilisées :
 *   - Note : Doit contenir les colonnes EC et Moyenne
 * 
 * Gestion des erreurs :
 *   - Retourne NULL si aucun étudiant n'a de note pour l'EC
 *   - Gère automatiquement la division par zéro
 * 
 * Exemple d'appel :
 *   SELECT CalculerMoyenneClasseEC('INF101') FROM dual;
 * 
 * Notes :
 *   - Les sorties de débogage (DBMS_OUTPUT) peuvent être commentées en production
 *   - La fonction suppose que la colonne Moyenne contient des valeurs valides
 * 
*/
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

/**
 * FONCTION : CalculerMoyenneClasseUE
 * 
 * Description :
 *   Calcule la moyenne d'une classe pour une Unité d'Enseignement (UE) donnée,
 *   pour un semestre et une année spécifiques, en agrégeant les moyennes individuelles des étudiants.
 * 
 * Paramètres :
 *   - p_codeUE (CHAR)   : Code de l'Unité d'Enseignement (ex: 'INF101')
 *   - p_annee (CHAR)    : Année académique (format: 'AAAA-AAAA')
 *   - p_semetre (CHAR)  : Semestre concerné (ex: '1', '2')
 * 
 * Retour :
 *   - NUMBER : Moyenne de la classe pour l'UE (arrondie à 2 décimales)
 *              0 si aucun étudiant n'a de note pour cette UE
 * 
 */
CREATE OR REPLACE FUNCTION CalculerMoyenneClasseUE(
    p_codeUE IN CHAR,
    p_annee IN CHAR,
    p_semetre IN CHAR
) RETURN NUMBER IS
    v_TotalMoyenne NUMBER := 0;   
    v_NbEtudiants NUMBER := 0;     
    v_MoyenneClasseUE NUMBER := 0;
BEGIN
    -- Parcours des étudiants ayant des notes pour cette UE
    FOR etudiant_rec IN (
        SELECT DISTINCT n.Etudiant
        FROM Note n
        INNER JOIN EC ec ON n.EC = ec.Code
        INNER JOIN UE ue ON ec.UE = ue.Code
        WHERE ue.Code = p_codeUE
          AND n.Annee = p_annee
          AND ue.Semestre = p_semetre
    ) LOOP
        DECLARE
            v_MoyenneUE NUMBER := 0;
        BEGIN
            -- Calcul de la moyenne UE pour l'étudiant courant
            v_MoyenneUE := CalculerMoyenneUeEtudiant(
                etudiant_rec.Etudiant,
                p_codeUE,
                p_annee,
                p_semetre
            );
            
            -- Mise à jour des totaux
            v_TotalMoyenne := v_TotalMoyenne + v_MoyenneUE;
            v_NbEtudiants := v_NbEtudiants + 1;
        END;
    END LOOP;

    -- Calcul final avec arrondi
    IF v_NbEtudiants > 0 THEN
        v_MoyenneClasseUE := ROUND(v_TotalMoyenne / v_NbEtudiants, 2);
    ELSE
        v_MoyenneClasseUE := 0;
    END IF;

    RETURN v_MoyenneClasseUE;
END CalculerMoyenneClasseUE;
/
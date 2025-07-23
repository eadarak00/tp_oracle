Create Or Replace Package ResultatEtudiant AS 
    Procedure Afficher_Relevee(num_carte IN CHAR, 
            niv IN CHAR, 
            sem IN CHAR, 
            an IN CHAR
            ); 
    Procedure Afficher_UE_Valide(    
                num_carte IN CHAR, 
                niv IN CHAR, 
                sem IN CHAR, 
                an IN CHAR
            ); 
    Function  CalculerMoyenneUeEtudiant (
                p_Matricule IN CHAR,      
                p_codeUE IN CHAR,        
                p_annee IN CHAR,           
                p_Semestre IN CHAR          
            ) RETURN NUMBER ; 
    Function CalcMoyenneSemestreEtudiant(
                etud IN CHAR,
                s IN CHAR,
                an IN CHAR
            ) RETURN NUMBER; 
End ResultatEtudiant ; 
/ 


-- le corps du package
Create Or Replace Package Body Gerant.ResultatEtudiant AS 
    PROCEDURE Afficher_Relevee(    
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
    DBMS_OUTPUT.PUT_LINE('                            RELEVE DE NOTES                                     ');
    DBMS_OUTPUT.PUT_LINE('================================================================================');
    DBMS_OUTPUT.PUT_LINE('Annee    : ' || an);
    DBMS_OUTPUT.PUT_LINE('Niveau   : ' || cy || ' ' || sem);
    DBMS_OUTPUT.PUT_LINE('Semestre : Semestre ' || sem);
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Numero de carte  : ' || num_carte);
    DBMS_OUTPUT.PUT_LINE('Nom et Prénom    : ' || nom_etudiant || ' ' || prenom_etudiant);
    DBMS_OUTPUT.PUT_LINE('Âge              : ' || age_etudiant || ' ans');
    DBMS_OUTPUT.PUT_LINE('Sexe              : ' || sexe_etudiant);
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(RPAD('Code EC', 10) || RPAD('Libelle', 25) || RPAD('CC', 10) || RPAD('Examen', 10) || RPAD('Moyenne', 10));
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
    DBMS_OUTPUT.PUT_LINE('Moyenne generale  : ' || moyenne_etudiant);
    DBMS_OUTPUT.PUT_LINE('Crédits obtenus    : ' || credits);
    DBMS_OUTPUT.PUT_LINE('Décision du jury   : ' || decision);
    DBMS_OUTPUT.PUT_LINE('Mention             : ' || mention_etudiant);
    DBMS_OUTPUT.PUT_LINE('Rang                : ' || rang_etudiant);
    DBMS_OUTPUT.PUT_LINE('================================================================================');

EXCEPTION
    WHEN student_not_found THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : Aucun etudiant trouve avec le numero de carte ' || num_carte);
    WHEN result_not_found THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : Aucun resultat trouve pour cet etudiant au semestre ' || sem || ' de l''année ' || an);
END;

-- Proc [2]
 PROCEDURE Afficher_UE_Valide(    
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
            DBMS_OUTPUT.PUT_LINE('Erreur : Aucun etudiant trouve avec ce numero de carte.');
            RAISE student_not_found;
    END;

    -- Affichage de l'entête
    DBMS_OUTPUT.PUT_LINE('================================================================================');
    DBMS_OUTPUT.PUT_LINE('                          LISTE DES EC VALIDÉS                                  ');
    DBMS_OUTPUT.PUT_LINE('================================================================================');
    
    -- Afficher les en-têtes des colonnes
    DBMS_OUTPUT.PUT_LINE(
        RPAD('Code_EC', 10) || RPAD('Libelle_EC', 30) || RPAD('Coef', 5) ||
        RPAD('Credits', 8) || RPAD('CC', 6) || RPAD('Exam', 6) || RPAD('Moyenne', 8)
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

        -- Affichage formaté des donnees
        DBMS_OUTPUT.PUT_LINE(
            RPAD(rec.Code_EC, 10) || RPAD(rec.Libelle_EC, 30) || RPAD(rec.Coefficient_EC, 5) ||
            RPAD(rec.Credit_EC, 8) || RPAD(rec.CC, 6) || RPAD(rec.Exam, 6) || RPAD(rec.Moyenne_EC, 8)
        );
    END LOOP;

    -- Si aucun EC n'a eté validé
    IF aucun_ec_valide THEN
        DBMS_OUTPUT.PUT_LINE('Aucun EC valide pour cet etudiant.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------');

EXCEPTION
    WHEN student_not_found THEN
        -- Gestion de l'exception si l'étudiant n'existe pas
        DBMS_OUTPUT.PUT_LINE('Procedure interrompue : Étudiant introuvable.');
    WHEN OTHERS THEN
        -- Gestion de toute autre erreur
        DBMS_OUTPUT.PUT_LINE('Erreur inattendue : ' || SQLERRM);
END;

-- Fonc[1]
 FUNCTION CalculerMoyenneUeEtudiant (
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

--- Fonc[2]
 FUNCTION CalcMoyenneSemestreEtudiant(
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


End ResultatEtudiant ; 
/
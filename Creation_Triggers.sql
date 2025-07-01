--Fichier pour les Requetes;

--DROP des triggers
DROP TRIGGER Mat_Etudiant;
DROP TRIGGER Code_EC;
DROP TRIGGER Code_UE;
DROP TRIGGER Calculer_Moyenne;
DROP TRIGGER Verifier_Validite;

/* TRIGGER
-- attribue de manière automatique un numéro de matricule à chaque étudiant ;
-- vérifie la validité du sexe qui ne peut prendre que Masculin ou Féminin ;
-- attribue de manière automatique une adresse e-mail à chaque nouvel étudiant ;
*/
Create Trigger Mat_Etudiant Before Insert On Etudiant For Each Row
	Declare
		i 			Smallint ;
		j 			Smallint ;
		k 			Smallint ;
		l 			Smallint ;
		b 			Smallint ;
		q 			Smallint ;
		y 			Smallint ;
		s 			Varchar(8) ;
		n 			Varchar(15) ;
		p 			Varchar(25) ;
		e 			Varchar(20) ;
		c1	 		Varchar(10) ;
		c 			Varchar(5) ;
		m 			VarChar(8) ;
		o 			Varchar(10) ;
		mail 		Varchar(10) ;
		v 			Char(2) ;
		h 			Char(1) ;
		d 			Char(1) ;
		Cursor C_Email Is Select Email From Etudiant ;
Begin
	v := :New.Niveau ;
	s := :New.Sexe ;
	n := :New.Nom ;
	p := :New.Prenom ;

	Select Count(*) Into i From Etudiant Where Niveau = v ;
	i := i + 1 ;
	If i <= 7 Then
		If v = 'L1' Then
			m := Concat('2023', '000') ;
			m := Concat(m, i) ;
		Elsif v = 'L2' Then
			m := Concat('2022', '000') ;
			m := Concat(m, i) ;
		Elsif v = 'L3' Then 
			m := Concat('2021', '000') ;
			m := Concat(m, i) ;
		Else
			i := 'a' ;
		End If ;
	Else
		i := 'a' ;
	End If ;

	If (s != 'Feminin') and (s != 'Masculin') Then
		i := 'a' ;
	End If ;

	l := Length(p) ;
	c := Lower(Substr(p, 1, 1)) ;
	h := Lower(Substr(n, 1, 1)) ;
	For j In 2 .. l Loop
		c1 := Substr(p, j, 1) ;
		If (c1 = ' ') and (l > j + 1) Then
			k := j + 1 ;
			d := Lower(Substr(p, k, 1)) ;
			c := Concat(c, d) ;
		End If ;
	End Loop ;
	e := Concat(c, '.') ;
	e := Concat(e, h) ;
	q := Length(e) ;
	y := 0 ;

	For a In C_Email Loop
		mail := Substr(a.Email, 1, q) ;
		If e = mail Then
			y := y + 1 ;
		End If ;
	End Loop ;
	If y = 0 Then
		e := Concat(e, '@zig.univ.sn') ;
	Else
		e := Concat(e, y) ;
		e := Concat(e, '@zig.univ.sn') ;
	End If ;

	:New.Matricule := m ;
	:New.Email := e ;

End ;
/

/*
	TRIGGER
--- Attribue automatiquement les codes des UE.
*/
CREATE TRIGGER Code_UE BEFORE INSERT ON UE FOR EACH ROW
BEGIN
    DECLARE
        c VARCHAR2(6);
        s CHAR(1) := :NEW.Semestre;
        cy VARCHAR2(8) := :NEW.Cycle;
        n SMALLINT;

    BEGIN
        -- Compter les UE existantes pour le même semestre et cycle
        SELECT COUNT(*) + 1 INTO n FROM UE WHERE Semestre = s AND Cycle = cy;

        -- Générer le code en fonction du cycle et du semestre
        IF cy = 'Licence' THEN
            CASE s
                WHEN '1' THEN c := CONCAT('INF11', n);
                WHEN '2' THEN c := CONCAT('INF12', n);
                WHEN '3' THEN c := CONCAT('INF23', n);
                WHEN '4' THEN c := CONCAT('INF24', n);
                WHEN '5' THEN c := CONCAT('INF35', n);
                WHEN '6' THEN c := CONCAT('INF36', n);
            END CASE;
        ELSIF cy = 'Master' THEN
            CASE s
                WHEN '1' THEN c := CONCAT('INF41', n);
                WHEN '2' THEN c := CONCAT('INF42', n);
                WHEN '3' THEN c := CONCAT('INF53', n);
                WHEN '4' THEN c := CONCAT('INF54', n);
            END CASE;
        END IF;

        -- Affecter le code généré à la nouvelle ligne
        :NEW.Code := c;
    END;
END;
/

/*
	TRIGGER
--- Attribue automatiquement les codes des EC.
*/

CREATE OR REPLACE TRIGGER Code_EC BEFORE INSERT ON EC FOR EACH ROW
DECLARE
    c VARCHAR2(7);
    cd CHAR(6) := :NEW.UE;
    n SMALLINT; 
BEGIN
    -- Compter les EC existants pour l'UE
    SELECT COUNT(*) + 1 INTO n FROM EC WHERE UE = cd;

    c := CONCAT(cd,n);
    :NEW.Code := c; 
END;
/

/*
	TRIGGER
	--	 Calcule et modifie la moyenne de l’EC pour chaque étudiant dès que les notes de contrôle et d’examen sont données (Insertion ou modification) ; 
*/

CREATE OR REPLACE TRIGGER Calculer_Moyenne BEFORE INSERT OR UPDATE ON Note FOR EACH ROW
BEGIN
    :NEW.Moyenne := (:NEW.Controle * 0.3) + (:NEW.Examen * 0.7);
END;
/


/*
	TRIGGER
	-- vérifie la validité du résultat qui ne peut prendre que Validé ou Ajourné. 
*/
CREATE OR REPLACE TRIGGER Verifier_Validite
BEFORE INSERT OR UPDATE ON Resultat
FOR EACH ROW
BEGIN
    IF :NEW.Moyenne < 10 THEN
        :NEW.Resultat := 'Ajourne';
    ELSE
        :NEW.Resultat := 'Valide';
    END IF;
END;
/
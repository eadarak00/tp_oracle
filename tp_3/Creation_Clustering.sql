DROP CLUSTER cluster_etudiant;
DROP CLUSTER cluster_ec;
DROP CLUSTER cluster_ue;

DROP TABLE EC1;
DROP TABLE UE1;
DROP TABLE Etudiant1;

DROP TRIGGER Mat_Etudiant1;

CREATE CLUSTER cluster_etudiant (
    Nom VARCHAR2(15), 
    Prenom VARCHAR2(60)
)
Size 512;


CREATE CLUSTER cluster_ue(
    Code CHAR(6),
    Libelle VARCHAR2(60)
)
SIZE 1024;

CREATE CLUSTER cluster_ec(
    Code CHAR(7),
    Libelle VARCHAR2(60)
)
SIZE 1024;

--Creation Table "Etudiant1"
CREATE TABLE Etudiant1 (
    Matricule CHAR(8),
    Nom VARCHAR2(15),
    Prenom VARCHAR2(60),
    Age SMALLINT,
    Sexe VARCHAR2(8),
    Email VARCHAR2(30),
    Niveau CHAR(2),
    CONSTRAINT pk_etudiant1 PRIMARY KEY (Matricule)
) CLUSTER cluster_etudiant(Nom, Prenom);


--Creation Table "UE"
CREATE TABLE UE1 (  
    Code CHAR(6),
    Libelle VARCHAR2(60),
    Coefficient SMALLINT,
    Credit SMALLINT,
    Semestre CHAR(1),
    Cycle VARCHAR2(8),
    CONSTRAINT pk_ue1 PRIMARY KEY (Code),
    CONSTRAINT fk_ue1_semestre FOREIGN KEY (Semestre, Cycle) REFERENCES Semestre(Numero, Cycle)
)CLUSTER cluster_ue(Code, Libelle);

--Creation Table "EC"
CREATE TABLE EC1 (
    Code CHAR(7),
    Libelle VARCHAR2(60),
    Coefficient SMALLINT,
    Credit SMALLINT,
    UE CHAR(6),
    CONSTRAINT pk_ec1 PRIMARY KEY (Code),
    CONSTRAINT fk_ec1_ue1 FOREIGN KEY (UE) REFERENCES UE (Code)
)CLUSTER cluster_ec(Code, Libelle);


----
Create Trigger Mat_Etudiant1 Before Insert On Etudiant1 For Each Row
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
		p 			Varchar(60) ;
		e 			Varchar(20) ;
		c1	 		Varchar(10) ;
		c 			Varchar(5) ;
		m 			VarChar(8) ;
		o 			Varchar(10) ;
		mail 		Varchar(10) ;
		v 			Char(2) ;
		h 			Char(1) ;
		d 			Char(1) ;
		Cursor C_Email Is Select Email From Etudiant1 ;
Begin
	v := :New.Niveau ;
	s := :New.Sexe ;
	n := :New.Nom ;
	p := :New.Prenom ;

	Select Count(*) Into i From Etudiant1 Where Niveau = v ;
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


CREATE INDEX index_cluster_etudiant ON CLUSTER cluster_etudiant;


-- Etudiant1 de la L1
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('DFALL', 'JAbdou', 22, 'Masculin', 'L1') ;
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('DIATTA', 'Josephine', 21, 'Feminin', 'L1') ;
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('NDOYE', 'Cheikh Tidiane', 20, 'Masculin', 'L1') ;
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('GOMIS', 'Jean Paul', 23, 'Masculin', 'L1') ;
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('GAYE', 'El Hadji Issa', 21, 'Masculin', 'L1') ;
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('DSOW', 'JAbibatou', 21, 'Feminin', 'L1') ;
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('DIOP', 'Jacques', 22, 'Masculin', 'L1') ;

-- -- Etudiant1 de la L2
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('GUEYE', 'Cheikh Abdou', 23, 'Masculin', 'L2') ;
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('GAYE', 'El Hadji Issa', 22, 'Masculin', 'L2') ;
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('DIOP', 'Adji Ndeye Astou Mbene', 24, 'Feminin', 'L2') ;
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('DIAGNE', 'Cheikh Abdou', 22, 'Masculin', 'L2') ;
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('DIEDHIOU', 'Fatoumata', 23, 'Feminin', 'L2') ;
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('NDIAYE', 'Khadidiatou', 21, 'Feminin', 'L2') ;
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('GUEYE', 'Cheikh Abdou', 22, 'Masculin', 'L2') ;

-- -- Etudiant1 de la L3
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('NDIAYE', 'Ndeye Coumba Mbaye', 22, 'Feminin', 'L3') ;
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('SECK', 'Alboury', 23, 'Masculin', 'L3') ;
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('DIAGNE', 'Ndeye Coumba', 24, 'Feminin', 'L3') ;
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('DIEDHIOU', 'Albert Louis', 25, 'Masculin', 'L3') ;
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('MENDY', 'Léontine Nicole', 24, 'Feminin', 'L3') ;
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('NDIAYE', 'Fatoumatou Zahra', 23, 'Feminin', 'L3') ;
Insert Into Etudiant1 (Nom, Prenom, Age, Sexe, Niveau) Values ('LO', 'El Hadji Mouhamadou Ass', 23, 'Masculin', 'L3') ;



-- Insert Into Etudiant1(Nom, Prenom, Age, Sexe, Niveau) Select Nom, Prenom, Age, Sexe, Niveau From etudiant;
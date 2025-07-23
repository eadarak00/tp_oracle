-- creation Les synonymes Publics Etu et Sem pour les tables Etudiant et Semestre ;
CREATE PUBLIC SYNONYM Etu FOR Etudiant;

CREATE PUBLIC SYNONYM Sem FOR Semestre;

--Creation du synonyme privee pour resulta
CREATE SYNONYM Rst For Resultat;
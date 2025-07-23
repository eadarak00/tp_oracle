-- Creation d'un index sur les attributs Nom, Prenom de la table Etudiant
CREATE INDEX index_etudiant ON Etudiant(Nom, Prenom);

-- Creation d'un index sur les attributs Coefficient et Credit de la table UE ; 
CREATE INDEX index_UE ON UE(Coefficient, Credit);

-- Creation d'un index sur l’attribut Moyenne de la table Note ; 
CREATE INDEX index_Note ON Note(Moyenne);

-- Creation d'un index sur les attributs Resultat, Mention et Rang de la table Resultat.
CREATE INDEX index_resultat ON Resultat(Resultat, Mention, Rang);
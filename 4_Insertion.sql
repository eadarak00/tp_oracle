-- Etudiant de la L1
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('DFALL', 'JAbdou', 22, 'Masculin', 'L1') ;
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('DIATTA', 'Josephine', 21, 'Feminin', 'L1') ;
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('NDOYE', 'Cheikh Tidiane', 20, 'Masculin', 'L1') ;
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('GOMIS', 'Jean Paul', 23, 'Masculin', 'L1') ;
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('GAYE', 'El Hadji Issa', 21, 'Masculin', 'L1') ;
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('DSOW', 'JAbibatou', 21, 'Feminin', 'L1') ;
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('DIOP', 'Jacques', 22, 'Masculin', 'L1') ;
-- Etudiant de la L2
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('GUEYE', 'Cheikh Abdou', 23, 'Masculin', 'L2') ;
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('GAYE', 'El Hadji Issa', 22, 'Masculin', 'L2') ;
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('DIOP', 'Adji Ndeye Astou Mbene', 24, 'Feminin', 'L2') ;
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('DIAGNE', 'Cheikh Abdou', 22, 'Masculin', 'L2') ;
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('DIEDHIOU', 'Fatoumata', 23, 'Feminin', 'L2') ;
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('NDIAYE', 'Khadidiatou', 21, 'Feminin', 'L2') ;
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('GUEYE', 'Cheikh Abdou', 22, 'Masculin', 'L2') ;
-- Etudiant de la L3
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('NDIAYE', 'Ndeye Coumba Mbaye', 22, 'Feminin', 'L3') ;
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('SECK', 'Alboury', 23, 'Masculin', 'L3') ;
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('DIAGNE', 'Ndeye Coumba', 24, 'Feminin', 'L3') ;
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('DIEDHIOU', 'Albert Louis', 25, 'Masculin', 'L3') ;
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('MENDY', 'Léontine Nicole', 24, 'Feminin', 'L3') ;
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('NDIAYE', 'Fatoumatou Zahra', 23, 'Feminin', 'L3') ;
Insert Into Etudiant (Nom, Prenom, Age, Sexe, Niveau) Values ('LO', 'El Hadji Mouhamadou Ass', 23, 'Masculin', 'L3') ;

-- Les semestres
Insert Into Semestre (Numero, Cycle, Annee) Values (1, 'Licence', '2023-2024') ; 
Insert Into Semestre (Numero, Cycle, Annee) Values (2, 'Licence', '2023-2024') ;
Insert Into Semestre (Numero, Cycle, Annee) Values (3, 'Licence', '2023-2024') ;
Insert Into Semestre (Numero, Cycle, Annee) Values (4, 'Licence', '2023-2024') ;
Insert Into Semestre (Numero, Cycle, Annee) Values (5, 'Licence', '2023-2024') ;
Insert Into Semestre (Numero, Cycle, Annee) Values (6, 'Licence', '2023-2024') ;

-- Les Unités d'enseignement
-- Licence 1
Insert Into UE (Libelle, Coefficient, Credit, Semestre, Cycle) Values ('Programmation 1', 4, 6, 1, 'Licence') ;
Insert Into UE (Libelle, Coefficient, Credit, Semestre, Cycle) Values ('Architecture et SE', 3, 5, 1, 'Licence') ;
Insert Into UE (Libelle, Coefficient, Credit, Semestre, Cycle) Values ('Programmation 2', 3, 6, 2, 'Licence') ;
Insert Into UE (Libelle, Coefficient, Credit, Semestre, Cycle) Values ('Systeme d''Information', 3, 6, 2, 'Licence') ;
-- Licence 2
Insert Into UE (Libelle, Coefficient, Credit, Semestre, Cycle) Values ('Outils Mathématiques', 2, 4, 3, 'Licence') ;
Insert Into UE (Libelle, Coefficient, Credit, Semestre, Cycle) Values ('Programmation web', 3, 6, 3, 'Licence') ;
Insert Into UE (Libelle, Coefficient, Credit, Semestre, Cycle) Values ('Programmation 3', 3, 6, 4, 'Licence') ;
Insert Into UE (Libelle, Coefficient, Credit, Semestre, Cycle) Values ('Réseaux et télécoms 1', 4, 6, 4, 'Licence') ;
-- Licence 3
Insert Into UE (Libelle, Coefficient, Credit, Semestre, Cycle) Values ('Programmation Objet', 3, 5, 5, 'Licence') ;
Insert Into UE (Libelle, Coefficient, Credit, Semestre, Cycle) Values ('Réseaux et télécoms 2', 4, 6, 5, 'Licence') ;
Insert Into UE (Libelle, Coefficient, Credit, Semestre, Cycle) Values ('Données', 3, 5, 6, 'Licence') ;
Insert Into UE (Libelle, Coefficient, Credit, Semestre, Cycle) Values ('IA et IoT', 3, 6, 6, 'Licence') ;

-- Les Eléments constitutifs
-- Semestre 1
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Algorithme 1', 2, 3, 'INF111') ;
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Pascal 1', 2, 3, 'INF111') ;
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Architecture', 1, 2, 'INF112') ;
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Système d''éxploitation', 2, 3, 'INF112') ;
-- Semestre 2
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Algorithme 2', 2, 3, 'INF121') ;
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Pascal 2', 2, 3, 'INF121') ;
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Merise', 1, 3, 'INF122') ;
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Base de données', 2, 3, 'INF122') ;
-- Semestre 3
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Proba et Stats', 1, 2, 'INF231') ;
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Logique combinatoire', 1, 2, 'INF231') ;
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Web statique', 1, 3, 'INF232') ;
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Web dynamique', 2, 3, 'INF232') ;
-- Semestre 4
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Structure de données', 2, 3, 'INF241') ;
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Langage C', 2, 3, 'INF241') ;
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Réseaux Informatique', 2, 4, 'INF242') ;
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Bases des télécoms', 1, 2, 'INF242') ;
-- Semestre 5
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Java', 2, 3, 'INF351') ;
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Visual Basic', 1, 2, 'INF351') ;
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Routage IP', 2, 4, 'INF352') ;
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Supports de transmission', 1, 2, 'INF352') ;
-- Semestre 6
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Base de données avancée', 2, 3, 'INF361') ;
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Admin bases de données', 1, 2, 'INF361') ;
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Intelligence Artificielle', 2, 3, 'INF362') ;
Insert Into EC (Libelle, Coefficient, Credit, UE) Values ('Objets connectés', 2, 3, 'INF362') ;

-- Les notes
-- Etudiant 2020001
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230001', 'INF1111', '2023-2024', 14.5, 11.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230001', 'INF1112', '2023-2024', 11.5, 11.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230001', 'INF1121', '2023-2024', 13.0, 11.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230001', 'INF1122', '2023-2024', 10.0, 11.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230001', 'INF1211', '2023-2024', 07.5, 11.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230001', 'INF1212', '2023-2024', 10.5, 11.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230001', 'INF1221', '2023-2024', 12.5, 11.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230001', 'INF1222', '2023-2024', 11.5, 11.75) ;
-- Etudiant 20230002
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230002', 'INF1111', '2023-2024', 10.5, 11.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230002', 'INF1112', '2023-2024', 11.5, 11.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230002', 'INF1121', '2023-2024', 03.0, 05.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230002', 'INF1122', '2023-2024', 10.0, 11.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230002', 'INF1211', '2023-2024', 12.5, 11.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230002', 'INF1212', '2023-2024', 05.5, 04.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230002', 'INF1221', '2023-2024', 12.5, 10.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230002', 'INF1222', '2023-2024', 11.5, 07.75) ;
-- Etudiant 20230003
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230003', 'INF1111', '2023-2024', 14.5, 15.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230003', 'INF1112', '2023-2024', 16.5, 14.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230003', 'INF1121', '2023-2024', 13.0, 14.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230003', 'INF1122', '2023-2024', 13.0, 16.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230003', 'INF1211', '2023-2024', 15.5, 17.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230003', 'INF1212', '2023-2024', 17.5, 14.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230003', 'INF1221', '2023-2024', 16.5, 12.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230003', 'INF1222', '2023-2024', 11.5, 14.75) ;
-- Etudiant 20230004
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230004', 'INF1111', '2023-2024', 12.5, 10.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230004', 'INF1112', '2023-2024', 15.5, 11.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230004', 'INF1121', '2023-2024', 06.0, 09.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230004', 'INF1122', '2023-2024', 10.0, 16.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230004', 'INF1211', '2023-2024', 05.5, 11.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230004', 'INF1212', '2023-2024', 12.5, 10.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230004', 'INF1221', '2023-2024', 08.5, 12.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230004', 'INF1222', '2023-2024', 12.5, 07.75) ;
-- Etudiant 20230005
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230005', 'INF1111', '2023-2024', 11.5, 10.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230005', 'INF1112', '2023-2024', 16.5, 09.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230005', 'INF1121', '2023-2024', 11.0, 10.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230005', 'INF1122', '2023-2024', 08.0, 04.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230005', 'INF1211', '2023-2024', 07.5, 05.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230005', 'INF1212', '2023-2024', 07.5, 08.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230005', 'INF1221', '2023-2024', 06.5, 08.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230005', 'INF1222', '2023-2024', 11.5, 04.75) ;
-- Etudiant 20230006
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230006', 'INF1111', '2023-2024', 14.5, 12.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230006', 'INF1112', '2023-2024', 11.5, 16.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230006', 'INF1121', '2023-2024', 13.0, 12.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230006', 'INF1122', '2023-2024', 14.0, 11.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230006', 'INF1211', '2023-2024', 15.5, 11.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230006', 'INF1212', '2023-2024', 12.5, 13.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230006', 'INF1221', '2023-2024', 12.5, 14.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230006', 'INF1222', '2023-2024', 13.5, 12.75) ;
-- Etudiant 20230007
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230007', 'INF1111', '2023-2024', 08.5, 10.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230007', 'INF1112', '2023-2024', 09.5, 12.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230007', 'INF1121', '2023-2024', 10.0, 08.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230007', 'INF1122', '2023-2024', 11.0, 05.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230007', 'INF1211', '2023-2024', 10.5, 14.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230007', 'INF1212', '2023-2024', 12.5, 09.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230007', 'INF1221', '2023-2024', 12.5, 10.75) ;
Insert Into Note (Etudiant, EC, Annee, CC, Examen) Values ('20230007', 'INF1222', '2023-2024', 11.5, 12.75) ;

-- Les résultats sont automatiquement inseres par une procedure 

-- Licence 1 semestre 1 

-- Licence 2 semestre 3

-- Licence 3 semestre 5

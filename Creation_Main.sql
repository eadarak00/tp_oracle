begin
    -- Configuration de l'environnement pour les accents
   execute immediate 'ALTER SESSION SET NLS_LANGUAGE=''FRENCH''';
   execute immediate 'ALTER SESSION SET NLS_TERRITORY=''FRANCE''';
    
    -- Suppression des resultats existants
   delete from resultat;

   dbms_output.put_line('************************************************');
   dbms_output.put_line('*** DEBUT DU TRAITEMENT PRINCIPAL ***');
   dbms_output.put_line('************************************************');
   dbms_output.put_line(chr(10));
    
    -- ==============================================
    -- SECTION 1 : TRAITEMENT DES PROCEDURES
    -- ==============================================
   dbms_output.put_line('=== EXECUTION DES PROCEDURES ===');
   dbms_output.put_line('>> [1/6] Calcul des moyennes semestrielles...');
   calculer_moyenne_semestrielle(
      'L1',
      1,
      '2023-2024'
   );
   dbms_output.put_line('>> OK - Moyennes calculees');
   dbms_output.put_line(chr(10)
                        || '>> [2/6] Classement par merite...');
   afficher_etudiant_merite(
      'L1',
      1,
      '2023-2024'
   );
   dbms_output.put_line('>> OK - Classement etabli');
   dbms_output.put_line(chr(10)
                        || '>> [3/6] Generation releve etudiant...');
   afficher_relevee(
      '20230003',
      'L1',
      1,
      '2023-2024'
   );
   dbms_output.put_line('>> OK - Releve genere');
   dbms_output.put_line(chr(10)
                        || '>> [4/6] Verification UEs validees...');
   afficher_ue_valide(
      '20230001',
      'L1',
      1,
      '2023-2024'
   );
   dbms_output.put_line('>> OK - UEs validees verifiees');
   dbms_output.put_line(chr(10)
                        || '>> [5/6] Liste etudiants valides...');
   lister_etudiant_valides(
      'L1',
      1,
      '2023-2024'
   );
   dbms_output.put_line('>> OK - Liste produite');
   dbms_output.put_line(chr(10)
                        || '>> [6/6] Identification du majorant...');
   afficher_majorant(
      'L1',
      1,
      '2023-2024'
   );
   dbms_output.put_line('>> OK - Majorant identifie');
   dbms_output.put_line(chr(10)
                        || '=== PROCEDURES EXECUTEES AVEC SUCCES ===');
   dbms_output.put_line('************************************************');
   dbms_output.put_line(chr(10));
   
   -- ==============================================
   -- SECTION 2 : TRAITEMENT DES FONCTIONS 
   -- ==============================================
   dbms_output.put_line('=== EXECUTION DES FONCTIONS ===');

-- Bloc pour le calcul de moyenne UE
   declare
      v_moyenne_ue number;
      v_etudiant   char(8) := '20230001';
      v_ue         char(6) := 'INF111';
      v_annee      char(9) := '2023-2024';
      v_semestre         char(2) := '1';
   begin
      dbms_output.put_line('>> [F1] Calcul de la moyenne UE pour l''etudiant '
                           || v_etudiant
                           || ' dans l''UE '
                           || v_ue);
      v_moyenne_ue := calculermoyenneueetudiant(
         v_etudiant,
         v_ue,
         v_annee,
         v_semestre
      );
      dbms_output.put_line('>> Resultat : Moyenne UE '
                           || v_ue
                           || ' = '
                           || to_char(
         v_moyenne_ue,
         '990.99'
      )
                           || '/20');

      dbms_output.put_line('>> OK - Calcul moyenne UE termine');
   exception
      when others then
         dbms_output.put_line('>> ERREUR lors du calcul de la moyenne UE : ' || sqlerrm);
   end;

-- Bloc pour le calcul de moyenne semestrielle etudiant
   declare
      v_moyenne_semestre number;
      v_etudiant_sem     char(8) := '20230001';
      v_semestre         char(2) := '1';
      v_annee_sem        char(9) := '2023-2024';
   begin
      dbms_output.put_line(chr(10)
                           || '>> [F2] Calcul de la moyenne semestrielle pour l''etudiant '
                           || v_etudiant_sem
                           || ' (semestre '
                           || v_semestre
                           || ')');

      v_moyenne_semestre := calcmoyennesemestreetudiant(
         v_etudiant_sem,
         v_semestre,
         v_annee_sem
      );
      if v_moyenne_semestre is not null then
         dbms_output.put_line('>> Resultat : Moyenne semestrielle = '
                              || to_char(
            v_moyenne_semestre,
            '990.99'
         )
                              || '/20');
      else
         dbms_output.put_line('>> Aucune note disponible pour ce semestre');
      end if;

      dbms_output.put_line('>> OK - Calcul semestriel termine');
   exception
      when others then
         dbms_output.put_line('>> ERREUR lors du calcul semestriel : ' || sqlerrm);
   end;

-- Bloc pour le calcul de moyenne de classe
   declare
      v_moyenne_classe   number;
      v_nombre_etudiants number;
      v_classe           char(2) := '1';
      v_semestre_classe  char(2) := '1';
      v_annee_classe     char(9) := '2023-2024';
   begin
      dbms_output.put_line(chr(10)
                           || '>> [F3] Calcul de la moyenne de classe pour '
                           || v_classe
                           || ' (semestre '
                           || v_semestre_classe
                           || ')');

      v_moyenne_classe := calcmoyenneclassesemestre(
         v_semestre_classe,
         v_annee_classe
      );
   
   -- Recuperation separee du nombre d'etudiants
      select count(*)
        into v_nombre_etudiants
        from resultat
       where semestre = v_semestre_classe
         and annee = v_annee_classe;

      if v_moyenne_classe is not null then
         dbms_output.put_line('>> Resultat : Moyenne de classe = '
                              || to_char(
            v_moyenne_classe,
            '990.99'
         )
                              || '/20');
         dbms_output.put_line('>> Nombre d''etudiants pris en compte : ' || v_nombre_etudiants);
      else
         dbms_output.put_line('>> Aucun resultat disponible pour cette classe');
      end if;

      dbms_output.put_line('>> OK - Calcul moyenne classe termine');
   exception
      when others then
         dbms_output.put_line('>> ERREUR lors du calcul de la moyenne classe : ' || sqlerrm);
   end;

   -- Bloc pour le calcul de moyenne de classe par EC
   declare
      v_moyenne_ec number;
      v_ec_code    char(7) := 'INF1111';  -- Code de l'EC à analyser
      v_classe     char(2) := '1';       -- Classe concernee
   begin
      dbms_output.put_line(chr(10)
                           || '>> [F4] Calcul de la moyenne de classe pour l''EC '
                           || v_ec_code);
   
   -- Calcul de la moyenne pour l'EC specifie
      v_moyenne_ec := calculermoyenneclasseec(v_ec_code);
   
   -- Affichage des resultats
      if v_moyenne_ec is not null then
      -- Recuperation du nombre d'etudiants pour contexte
         declare
            v_nb_etudiants number;
         begin
            select count(distinct etudiant)
              into v_nb_etudiants
              from note
             where ec = v_ec_code;

            dbms_output.put_line('>> Resultat :');
            dbms_output.put_line('   - EC: ' || v_ec_code);
            dbms_output.put_line('   - Classe: ' || v_classe);
            dbms_output.put_line('   - Moyenne classe: '
                                 || to_char(
               v_moyenne_ec,
               '990.99'
            )
                                 || '/20');
            dbms_output.put_line('   - Etudiants evalues: ' || v_nb_etudiants);
         end;
      else
         dbms_output.put_line('>> Aucune note disponible pour cet EC');
      end if;

      dbms_output.put_line('>> OK - Calcul moyenne EC termine');
   exception
      when others then
         dbms_output.put_line('>> ERREUR lors du calcul EC: ' || sqlerrm);
   end;

   -- Bloc pour le calcul de moyenne de classe par UE
   declare
      v_moyenne_ue number;
      v_ue_code    char(6) := 'INF111';  -- Code de l'UE à analyser
      v_annee      char(9) := '2023-2024'; -- Annee scolaire
      v_semestre    char(2) := '1';       -- Classe concernee
   begin
      dbms_output.put_line(chr(10)
                           || '>> [F5] Calcul de la moyenne de classe pour l''UE '
                           || v_ue_code);
   
   -- Calcul de la moyenne pour l'UE specifiee
      v_moyenne_ue := calculermoyenneclasseue(
         v_ue_code,
         v_annee,
         v_semestre
      );
   
   -- Affichage des resultats
      if v_moyenne_ue > 0 then
      -- Recuperation du nombre d'etudiants pour contexte
         declare
            v_nb_etudiants number;
         begin
            select count(distinct n.etudiant)
              into v_nb_etudiants
              from note n
              join ec ec
            on n.ec = ec.code
             where ec.ue = v_ue_code
               and n.annee = v_annee;

            dbms_output.put_line('>> Resultat :');
            dbms_output.put_line('   - UE: ' || v_ue_code);
            dbms_output.put_line('   - Semestre: ' || v_semestre);
            dbms_output.put_line('   - Annee: ' || v_annee);
            dbms_output.put_line('   - Moyenne classe: '
                                 || to_char(
               v_moyenne_ue,
               '990.99'
            )
                                 || '/20');
            dbms_output.put_line('   - Etudiants evalues: ' || v_nb_etudiants);
         end;
      else
         dbms_output.put_line('>> Aucune note disponible pour cette UE');
      end if;

      dbms_output.put_line('>> OK - Calcul moyenne UE termine');
   exception
      when others then
         dbms_output.put_line('>> ERREUR lors du calcul UE: ' || sqlerrm);
   end;


   dbms_output.put_line(chr(10));
   dbms_output.put_line('=== FONCTIONS EXECUTEES AVEC SUCCES ===');
    -- ==============================================
    -- FIN DU TRAITEMENT
    -- ==============================================

   dbms_output.put_line('************************************************');
   dbms_output.put_line('*** TRAITEMENT TERMINE AVEC SUCCES ***');
   dbms_output.put_line('*** '
                        || to_char(
      sysdate,
      'DD/MM/YYYY HH24:MI:SS'
   )
                        || ' ***');
   dbms_output.put_line('************************************************');
end;
/

-- SET SERVEROUTPUT ON;
-- ALTER SESSION SET NLS_LANGUAGE = 'FRENCH';
--  ALTER SESSION SET NLS_TERRITORY = 'FRANCE';
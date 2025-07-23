BEGIN
    DBMS_SCHEDULER.CREATE_JOB(
        job_name => 'job_moyenne_semestre',
        job_type => 'EXECUTABLE',
        job_action => 'BEGIN calculer_moyenne_semestrielle; END;',
        start_date => SYSTIMESTAMP,
        repeat_interval => 'FREQ = daily; INTERVAL = 3',
        end_date => '10/10/25 11:55:03,397000 +00:00',
        auto_drop => true,
        enabled => true
    );
END;
/


BEGIN
    DBMS_SCHEDULER.CREATE_JOB(
        job_name => 'job_resultat_classe',
        job_type => 'EXECUTABLE',
        job_action => 'BEGIN afficher_etudiant_merite; END;',
        start_date => SYSTIMESTAMP,
        repeat_interval => 'FREQ = Minutely; interval=5',
        end_date => '10/07/25 12:50:00,397000 +00:00',
        auto_drop => true,
        enabled => true
    );
END;
/
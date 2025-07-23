-- Creation de la sequence AutoIncrement
CREATE SEQUENCE AutoIncrement
START WITH 1 INCREMENT BY 1;

--Creation de la Table de TEST
CREATE  Table TestIncrement(
    Numero INT,
    Libelle VARCHAR(15),
    CONSTRAINT pk_test PRIMARY KEY(Numero)
);

--creation de la trigger 
CREATE OR REPLACE TRIGGER INSERT_Test BEFORE INSERT ON TestIncrement FOR EACH ROW
BEGIN
    :New.Numero := AutoIncrement.NEXTVAL;
END;
/

INSERT INTO TestIncrement(Libelle) VALUES ('Test 1');
INSERT INTO TestIncrement(Libelle) VALUES ('Test 2');


-- creation de la sequence IntImpair
CREATE  SEQUENCE IntImpair 
START WITH 1 
INCREMENT BY 2
MAXVALUE 10
CYCLE
CACHE 5;


CREATE  Table TestImpair(
    Numero INT,
    Libelle VARCHAR(15),
    CONSTRAINT pk_testImpair PRIMARY KEY(Numero)
);


CREATE OR REPLACE TRIGGER Test_Impair BEFORE INSERT ON TestImpair FOR EACH ROW
BEGIN
    :New.Numero := IntImpair.NEXTVAL;
END;
/




-- INSERT INTO TestImpair(Libelle) VALUES ('Test 1');
-- INSERT INTO TestImpair(Libelle) VALUES ('Test 2');
-- INSERT INTO TestImpair(Libelle) VALUES ('Test 3');
-- INSERT INTO TestImpair(Libelle) VALUES ('Test 4');
-- INSERT INTO TestImpair(Libelle) VALUES ('Test 5');
-- INSERT INTO TestImpair(Libelle) VALUES ('Test 6');

CREATE  Table TestIncrement2(
    Numero INT,
    Libelle VARCHAR(15),
    CONSTRAINT pk_test2 PRIMARY KEY(Numero)
);


INSERT INTO TestIncrement2 SELECT * FROM TestIncrement;
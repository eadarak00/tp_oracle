--Fichier de creation des utilisateurs

Create USER gerant Identified By Difficile23
Default Tablespace  		USERS
Temporary Tablespace  		TEMP
Quota 				Unlimited on USERS
Password  			Expire
Account  			Unlock
;

Create USER employe Identified By Facile2023
Default Tablespace  		USERS
Temporary Tablespace  		TEMP
Quota 				Unlimited on USERS
Password  			Expire
Account  			Unlock
;

Grant Create Session To gerant ; 
--resource permet de creer des ressources
Grant Resource To gerant ; 
Grant DBA To gerant ; 
Grant SysDBA To gerant ;

Grant Create Session To employe ;
Grant Resource To employe ; 

Connect gerant/Difficile23

*/
  Sreyashi Ghosh
  PMID : 21746750
  Table: 3 
   
  Outcome variable : ASTHMA_NOW
  Explanatory variable of interest : SMOKDAY2
   
  All explanatory variables (n=6) 
- Numeric variable(s) : MENTHLTH
- Categorical variable(s) (> 2 levels) : SMOKDAY2, AGEGROUP
- Categorical variable(s) (= 2 levels) : SEX, ADDEPEV3, DECIDE

/* ;

*task 1;

* set location ;

LIBNAME p '~/BIST0551/Project';


* check the contents of the data set: ps23.sas7bdat;

   PROC CONTENTS DATA=p.ps23;
   RUN; 
 
* formatting data;
 
 OPTIONS FMTSEARCH=(p.ps23format);
 
  PROC PRINT DATA=p.ps23 (OBS=10);
 	VAR ASTHMA_NOW SMOKDAY2 MENTHLTH AGEGROUP SEX ADDEPEV3 DECIDE;
 RUN;


 * create the analysis working data set with only 7 needed variables;
 
 DATA p.working;
 	SET p.ps23;
 	KEEP ASTHMA_NOW SMOKDAY2 MENTHLTH AGEGROUP SEX ADDEPEV3 DECIDE;
 RUN;
 
   PROC PRINT DATA=p.working (OBS=10);
 	VAR ASTHMA_NOW SMOKDAY2 MENTHLTH AGEGROUP SEX ADDEPEV3 DECIDE;
 RUN;
 
*task 2;
 
* check the normality of MENTHLTH by group;

PROC UNIVARIATE DATA=p.working NORMAL;
   VAR MENTHLTH;
   CLASS ASTHMA_NOW;
RUN;


* not normally distributed so need to run the Wilcoxon rank sum test;

PROC NPAR1WAY DATA=p.working WILCOXON;
   VAR MENTHLTH;
   CLASS ASTHMA_NOW;
RUN; 

* compare the distribution of categorical variables;

PROC FREQ DATA=p.working;
   TABLES SMOKDAY2*ASTHMA_NOW AGEGROUP*ASTHMA_NOW SEX*ASTHMA_NOW ADDEPEV3*ASTHMA_NOW DECIDE*ASTHMA_NOW / CHISQ NOPERCENT NOROW EXPECTED;
RUN;

*task 3;

*logistic regression;

PROC LOGISTIC DATA=p.working;
   CLASS  ADDEPEV3/ PARAM=REF;
   MODEL  ASTHMA_NOW (EVENT="YES") = ADDEPEV3;   
RUN; 

PROC LOGISTIC DATA=p.working;
   MODEL  ASTHMA_NOW (EVENT="YES") = MENTHLTH;
RUN;

PROC LOGISTIC DATA=p.working;
   ClASS  SEX (REF="Male") / PARAM=REF;     * 1 = Male 2 = Female;
   MODEL  ASTHMA_NOW (EVENT="YES") = SEX;     * 1 : Yes  2: No ; 
RUN;

PROC LOGISTIC DATA=p.working;
   CLASS  AGEGROUP/ PARAM=REF;
   MODEL  ASTHMA_NOW (EVENT="YES") = AGEGROUP;   
RUN;

PROC LOGISTIC DATA=p.working;
   CLASS  SMOKDAY2 (REF="Not at all")/ PARAM=REF;
   MODEL  ASTHMA_NOW (EVENT="YES") = SMOKDAY2;   
RUN;

PROC LOGISTIC DATA=p.working;
   CLASS  DECIDE/ PARAM=REF;
   MODEL  ASTHMA_NOW (EVENT="YES") = DECIDE;   
RUN;

* task 4; 

*model selection;

* I will use Forward selection for final model;

* run all 3 types;


PROC LOGISTIC DATA=p.working;
   ClASS  SEX (REF="Male") AGEGROUP SMOKDAY2 (REF="Not at all")  DECIDE ADDEPEV3/ PARAM=REF;     
   MODEL  ASTHMA_NOW (EVENT="YES") =SMOKDAY2 MENTHLTH ADDEPEV3 AGEGROUP SEX DECIDE / SELECTION= BACKWARD INCLUDE = 3 ;      
RUN;

PROC LOGISTIC DATA=p.working;
   ClASS  SEX (REF="Male") AGEGROUP SMOKDAY2 (REF="Not at all")  DECIDE ADDEPEV3 / PARAM=REF;     
   MODEL  ASTHMA_NOW (EVENT="YES") = SMOKDAY2 MENTHLTH ADDEPEV3 AGEGROUP SEX DECIDE / SELECTION= FORWARD INCLUDE = 3 ;      
RUN;

PROC LOGISTIC DATA=p.working;
   ClASS  SEX (REF="Male") AGEGROUP SMOKDAY2 (REF="Not at all")  DECIDE ADDEPEV3 / PARAM=REF;     
   MODEL  ASTHMA_NOW (EVENT="YES") = SMOKDAY2 MENTHLTH ADDEPEV3 AGEGROUP SEX DECIDE  / SELECTION= STEPWISE INCLUDE = 3 ;      
RUN;


* evaluate final model;


PROC LOGISTIC DATA=p.working PLOTS= (ROC INFLUENCE DFBETAS);
   ClASS  SMOKDAY2 (REF="Not at all") ADDEPEV3 SEX (REF="Male") DECIDE  / PARAM=REF;     
   MODEL  ASTHMA_NOW (EVENT="YES") = SMOKDAY2 MENTHLTH ADDEPEV3 SEX DECIDE/ RSQUARE LACKFIT;      
RUN;





   


 
 

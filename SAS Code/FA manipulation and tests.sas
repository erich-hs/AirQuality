/*Final Assignment DANA - Ho Chi Minh database*/
/*Creates library for Final Assignment - FA*/
libname FA base "/folders/myfolders/DANA/FA";

proc import datafile="/folders/myfolders/DANA/FA/HoChiMinh_Master_Clean.csv" 
	dbms=csv 
	out=fa.hanoi_master;
run;

ODS RTF FILE="/folders/myfolders/DANA/FA/correl_analisys.rtf" startpage=no;
ods noproctitle;
ods graphics on;

/*Creates a report with the mean values of AQI per day*/
ods exclude all;
proc means data=fa.hanoi_master nway;
	class year day;
	var AQI;
	output out=fa.aqi_year mean=AQI_Ave;
run;
proc report data=fa.aqi_year
		out = fa.aqi_day;
			column Year Day AQI_Ave;
			define Year/group;
			define Day /group;
   			define AQI_Ave /analysis mean; 
run;
/*Creates a table where all years are together*/
/*AQI per day for all years*/
proc sql;
	create table fa.aqi_day_2016 as
	select Day, AQI_Ave as AQI_2016 
	from fa.aqi_day
	where year = 2016
	;
quit;
proc sql;
	create table fa.aqi_day_2017 as
	select Day, AQI_Ave as AQI_2017 
	from fa.aqi_day
	where year = 2017
	;
quit;
proc sql;
	create table fa.aqi_day_2018 as
	select Day, AQI_Ave as AQI_2018
	from fa.aqi_day
	where year = 2018
	;
quit;
proc sql;
	create table fa.aqi_day_2019 as
	select Day, AQI_Ave as AQI_2019
	from fa.aqi_day
	where year = 2019
	;
quit;
proc sql;
	create table fa.aqi_day_2020 as
	select Day, AQI_Ave as AQI_2020
	from fa.aqi_day
	where year = 2020
	;
quit;
proc sql;
	create table fa.aqi_day_2021 as
	select Day, AQI_Ave as AQI_2021
	from fa.aqi_day
	where year = 2021
	;
quit;
/*JOINS all the table into a single one for making correlation among years*/
proc sql;
   	create table fa.AQI_all_years as
   	select l.*, a.AQI_2017, b.AQI_2018, c.AQI_2019, d.AQI_2020, e.AQI_2021
   	from fa.aqi_day_2016 as l, fa.aqi_day_2017 as a, fa.aqi_day_2018 as b,
   			fa.aqi_day_2019 as c, fa.aqi_day_2020 as d, fa.aqi_day_2021 as e
    where l.day=a.day and l.day=b.day and l.day=c.day and l.day=d.day and l.day=e.day
    ;
quit;
/*RUNS correl analysis*/
ods exclude none;
proc corr data=fa.AQI_all_years plots=matrix(histogram);
	var AQI_2016
		AQI_2017
		AQI_2018
		AQI_2019 
		AQI_2020 
		AQI_2021;	
run;

proc corr data=fa.AQI_all_years plots=matrix(histogram);
	var 
		AQI_2017
		AQI_2018
		AQI_2019 
		AQI_2020 
		AQI_2021;	
run;

title;
ods rtf close;

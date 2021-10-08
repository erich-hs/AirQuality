/*Final Assignment DANA - Ho Chi Minh database*/
/*Creates library for Final Assignment - FA*/
libname FA base "/folders/myfolders/DANA/FA";

proc import datafile="/folders/myfolders/DANA/FA/HoChiMinh_Master_Clean.csv" 
	dbms=csv 
	out=fa.hanoi_master;
run;

ODS RTF FILE="/folders/myfolders/DANA/FA/categorical_tables.rtf" startpage=no;
ods noproctitle;
ods graphics on;


data fa.AQI_all_years;
	set fa.AQI_all_years;
	if AQI_2016 <= 50 then AQICat_2016= 1;
	else if AQI_2016 > 50 and AQI_2016 <=100 then AQICat_2016 = 2;
	else if AQI_2016 > 100 and AQI_2016 <=150 then AQICat_2016 = 3;
	else if AQI_2016 > 150 and AQI_2016 <=200 then AQICat_2016 = 4; 
	else if AQI_2016 > 200 and AQI_2016 <=300 then AQICat_2016=4;
	else if AQI_2016 > 300 then AQICat_2016=5;
	
	if AQI_2017 <= 50 then AQICat_2017= 1;
	else if AQI_2017 > 50 and AQI_2017 <=100 then AQICat_2017 = 2;
	else if AQI_2017 > 100 and AQI_2017 <=150 then AQICat_2017 = 3;
	else if AQI_2017 > 150 and AQI_2017 <=200 then AQICat_2017 = 4; 
	else if AQI_2017 > 200 and AQI_2017 <=300 then AQICat_2017=4;
	else if AQI_2017 > 300 then AQICat_2017=5;
	
	if AQI_2018 <= 50 then AQICat_2018= 1;
	else if AQI_2018 > 50 and AQI_2018 <=100 then AQICat_2018 = 2;
	else if AQI_2018 > 100 and AQI_2018 <=150 then AQICat_2018 = 3;
	else if AQI_2018 > 150 and AQI_2018 <=200 then AQICat_2018 = 4; 
	else if AQI_2018 > 200 and AQI_2018 <=300 then AQICat_2018=4;
	else if AQI_2018 > 300 then AQICat_2018=5;
	
	if AQI_2019 <= 50 then AQICat_2019= 1;
	else if AQI_2019 > 50 and AQI_2019 <=100 then AQICat_2019 = 2;
	else if AQI_2019 > 100 and AQI_2019 <=150 then AQICat_2019 = 3;
	else if AQI_2019 > 150 and AQI_2019 <=200 then AQICat_2019 = 4; 
	else if AQI_2019 > 200 and AQI_2019 <=300 then AQICat_2019=4;
	else if AQI_2019 > 300 then AQICat_2019=5;
	
	if AQI_2020 <= 50 then AQICat_2020= 1;
	else if AQI_2020 > 50 and AQI_2020 <=100 then AQICat_2020 = 2;
	else if AQI_2020 > 100 and AQI_2020 <=150 then AQICat_2020 = 3;
	else if AQI_2020 > 150 and AQI_2020 <=200 then AQICat_2020 = 4; 
	else if AQI_2020 > 200 and AQI_2020 <=300 then AQICat_2020=4;
	else if AQI_2020 > 300 then AQICat_2020=5;
	
	if AQI_2021 <= 50 then AQICat_2021= 1;
	else if AQI_2021 > 50 and AQI_2021 <=100 then AQICat_2021 = 2;
	else if AQI_2021 > 100 and AQI_2021 <=150 then AQICat_2021 = 3;
	else if AQI_2021 > 150 and AQI_2021 <=200 then AQICat_2021 = 4; 
	else if AQI_2021 > 200 and AQI_2021 <=300 then AQICat_2021=4;
	else if AQI_2021 > 300 then AQICat_2021=5;
		
run;
/*Creates the format for Low Medium High */
proc format;
   value AQIFmt 	1='Good'
   					2='Mod.'
                	3='Unh. for SG'
                	4='Unh.'
                	5='Very Unh.';
run;
/*Cross table analysis for ctegorical values per year*/
proc freq data =fa.aqi_all_years;
	format 	AQICat_2016 AQIFmt. AQICat_2017 AQIFmt.
			AQICat_2018 AQIFmt. AQICat_2019 AQIFmt.
			AQICat_2020 AQIFmt. AQICat_2021 AQIFmt.;
	
	tables AQICat_2021*AQICat_2016 /chisq nocum nocol norow nopercent;
   	tables AQICat_2021*AQICat_2017 /chisq nocum nocol norow nopercent;
   	tables AQICat_2021*AQICat_2018 /chisq nocum nocol norow nopercent;
   	tables AQICat_2021*AQICat_2019 /chisq nocum nocol norow nopercent;
   	tables AQICat_2021*AQICat_2020 /chisq nocum nocol norow nopercent;
run;

title;
ods rtf close;

libname FA base "/folders/myfolders/DANA/FA";

/*2. Importing data set of HANOI 2017 CSV*/
Data FA.Hanoi2017;
	infile '/folders/myfolders/DANA/FA/2017_12.csv' dlm=',' firstobs=2 missover;
	format Site $16. Parameter $17. Date_LT_ DATETIME13. Year 4. Month 2. Day 2. Hour 2. 
			NowCast_Conc_ 3.1 AQI 3.1 AQI_Category $30. Raw_Conc 3. Conc_Unit $5.
			Duration $4. QC_Name $10.;
		
	input 	Site Parameter Date_LT_:ANYDTDTM40. Year Month Day Hour NowCast_Conc_ 
			AQI AQI_Category $ Raw_Conc Conc_Unit $
			Duration QC_Name $;
			
	rename 	Date_LT_=Date
			AQI_Category=AQICat
			Raw_Conc=RawConc
			NowCast_Conc_=NowCastConc
			Conc_Unit= ConcUnit 
			QC_Name=QCName;
			
	put Date_LT_=DATETIME13.;
	options datestyle=dmy;
run;
/*3. Importing data set of HANOI 2018 CSV*/
Data FA.Hanoi2018;
	infile '/folders/myfolders/DANA/FA/2018_12.csv' dlm=',' firstobs=2 missover;
	format Site $16. Parameter $17. Date_LT_ DATETIME13. Year 4. Month 2. Day 2. Hour 2. 
			NowCast_Conc_ 3.1 AQI 3.1 AQI_Category $30. Raw_Conc 3. Conc_Unit $5.
			Duration $4. QC_Name $10.;
		
	input Site Parameter Date_LT_:ANYDTDTM40. Year Month Day Hour NowCast_Conc_ 
			AQI AQI_Category $ Raw_Conc Conc_Unit $
			Duration QC_Name $;
	
	rename 	Date_LT_=Date
			AQI_Category=AQICat
			Raw_Conc=RawConc
			NowCast_Conc_=NowCastConc
			Conc_Unit= ConcUnit 
			QC_Name=QCName;
			
	put Date_LT_=DATETIME13.;
	options datestyle=dmy;
run;
/*4. Importing data set of HANOI 2019 CSV*/
Data FA.Hanoi2019;
	infile '/folders/myfolders/DANA/FA/2019_12.csv' dlm=',' firstobs=2 missover;
	format Site $16. Parameter $17. Date_LT_ DATETIME13. Year 4. Month 2. Day 2. Hour 2. 
			NowCast_Conc_ 3.1 AQI 3.1 AQI_Category $30. Raw_Conc 3. Conc_Unit $5.
			Duration $4. QC_Name $10.;
		
	input Site Parameter Date_LT_:ANYDTDTM40. Year Month Day Hour NowCast_Conc_ 
			AQI AQI_Category $ Raw_Conc Conc_Unit $
			Duration QC_Name $;
			
	rename 	Date_LT_=Date
			AQI_Category=AQICat
			Raw_Conc=RawConc
			NowCast_Conc_=NowCastConc
			Conc_Unit= ConcUnit 
			QC_Name=QCName;
			
	put Date_LT_=DATETIME13.;
	options datestyle=dmy;
run;
/*4. Importing data set of HANOI 2020 CSV*/
Data FA.Hanoi2020;
	infile '/folders/myfolders/DANA/FA/2020_12.csv' dlm=',' firstobs=2 missover;
	format Site $16. Parameter $17. Date_LT_ DATETIME13. Year 4. Month 2. Day 2. Hour 2. 
			NowCast_Conc_ 3.1 AQI 3.1 AQI_Category $30. Raw_Conc 3. Conc_Unit $5.
			Duration $4. QC_Name $10.;
		
	input Site Parameter Date_LT_:ANYDTDTM40. Year Month Day Hour NowCast_Conc_ 
			AQI AQI_Category $ Raw_Conc Conc_Unit $
			Duration QC_Name $;
	
	rename 	Date_LT_=Date
			AQI_Category=AQICat
			Raw_Conc=RawConc
			NowCast_Conc_=NowCastConc
			Conc_Unit= ConcUnit 
			QC_Name=QCName;
			
	put Date_LT_=DATETIME13.;
	options datestyle=dmy;
run;
/*4. Importing data set of HANOI 2021 CSV*/
Data FA.Hanoi2021;
	infile '/folders/myfolders/DANA/FA/2021_02.csv' dlm=',' firstobs=2 missover;
	format Site $16. Parameter $17. Date_LT_ DATETIME13. Year 4. Month 2. Day 2. Hour 2. 
			NowCast_Conc_ 3.1 AQI 3.1 AQI_Category $30. Raw_Conc 3. Conc_Unit $5.
			Duration $4. QC_Name $10.;
		
	input Site Parameter Date_LT_:ANYDTDTM40. Year Month Day Hour NowCast_Conc_ 
			AQI AQI_Category $ Raw_Conc Conc_Unit $
			Duration QC_Name $;
	
	rename 	Date_LT_=Date
			AQI_Category=AQICat
			Raw_Conc=RawConc
			NowCast_Conc_=NowCastConc
			Conc_Unit= ConcUnit 
			QC_Name=QCName;
			
	put Date_LT_=DATETIME13.;
	options datestyle=dmy;
run;
/*****************************************************************************************************/
/*YEARS 2017-2021 DATA REPAIRING*/
/*2017 - FIXING VALUES OF '-999 */
proc freq data = fa.hanoi2017 nlevels;
	tables RawConc AQI NowCastConc;
run;
/*57 obs found with values of "***", on each 3 variables*/
/*2 obs greater than 300 in RawConc*/
/*Out of boundaries data replaced by missing status*/
data fa.hanoi2017_clean;
	set fa.hanoi2017;
	if (RawConc < 0 or RawConc > 300) then call missing (RawConc);
	if (AQI < 0 or AQI > 300) then call missing (AQI);
	if (NowCastConc < 0 or NowCastConc > 150) then call missing (NowCastConc);
	where year = 2017;
run; 
/*Replacing missing with MEDIANS*/
proc stdize data=fa.hanoi2017_clean
	out=fa.hanoi2017_clean
	reponly method=median;
run;
/*****************************************************************************************************/
/*2018 - FIXING VALUES */
proc freq data = fa.hanoi2018 nlevels;
	tables RawConc AQI NowCastConc;
run;
/*3 obs of -999 in rawConc
/*84 obs found with values of -999, on AQI NowCastConc*/
/*No obs greater than 300*/
/*Out of boundaries data replaced by missing status*/
data fa.hanoi2018_clean;
	set fa.hanoi2018;
	if (RawConc < 0 or RawConc > 300) then call missing (RawConc);
	if (AQI < 0 or AQI > 300) then call missing (AQI);
	if (NowCastConc < 0 or NowCastConc > 150) then call missing (NowCastConc);
	where year=2018;
run; 
/*Calculates Medians wihtout extreme negative values*/
/*NowCastConc 24.55 AQI 77 RawConc = 27*/
proc means data=FA.Hanoi2018_clean n min max mean median;
run; 
/*Replacing missing with MEDIANS*/
proc stdize data=fa.hanoi2018_clean
	out=fa.hanoi2018_clean
	reponly method=median;
run;
proc means data=FA.Hanoi2018_clean n min max mean median;
run; 
/*****************************************************************************************************/
/*2019 - FIXINg VALUES*/
proc freq data = fa.hanoi2019 nlevels;
	tables RawConc AQI NowCastConc;
run;
/*1 obs >300 in rawConc
/*4 obs found with values of -999, on AQI NowCastConc*/
/*Out of boundaries data replaced by missing status*/
data fa.hanoi2019_clean;
	set fa.hanoi2019;
	if (RawConc < 0 or RawConc > 300) then call missing (RawConc);
	if (AQI < 0 or AQI > 300) then call missing (AQI);
	if (NowCastConc < 0 or NowCastConc > 150) then call missing (NowCastConc);
	where year = 2019;
run; 
/*Calculates Medians wihtout extreme negative values*/
/*NowCastConc 34.6 AQI 98 RawConc = 33*/
proc means data=FA.Hanoi2019_clean n min max mean median;
run; 
/*Replacing missing with MEDIANS*/
proc stdize data=fa.hanoi2019_clean
	out=fa.hanoi2019_clean
	reponly method=median;
run;
proc means data=FA.Hanoi2019_clean n min max mean median;
run;
/*****************************************************************************************************/
/*2020 - FIXING VALUES*/
proc freq data = fa.hanoi2020 nlevels;
	tables RawConc AQI NowCastConc;
run;
/*4 obs >300 in rawConc
/*1,2,2 obs found with values of -999, on RawConc AQI NowCastConc*/
/*Out of boundaries data replaced by missing status*/
data fa.hanoi2020_clean;
	set fa.hanoi2020;
	if (RawConc < 0 or RawConc > 300) then call missing (RawConc);
	if (AQI < 0 or AQI > 300) then call missing (AQI);
	if (NowCastConc < 0 or NowCastConc > 150) then call missing (NowCastConc);
	where year = 2020;
run; 
/*Calculates Medians wihtout extreme negative values*/
/*NowCastConc 234.8 AQI 94 RawConc = 33*/
proc means data=FA.Hanoi2020_clean n min max mean median;
run; 
/*Replacing missing with MEDIANS*/
proc stdize data=fa.hanoi2020_clean
	out=fa.hanoi2020_clean
	reponly method=median;
run;
proc means data=FA.Hanoi2020_clean n min max mean median;
run;

/*****************************************************************************************************/
/*2021 - FIXING VALUES*/
proc freq data = fa.hanoi2021 nlevels;
	tables RawConc AQI NowCastConc;
run;
/*1 obs >300 in rawConc
/*0 obs found with values of -999, on RawConc AQI NowCastConc*/
/*Out of boundaries data replaced by missing status*/
data fa.hanoi2021_clean;
	set fa.hanoi2021;
	if (RawConc< 0 or RawConc > 300) then call missing (RawConc);
	if (AQI < 0 or AQI > 300) then call missing (AQI);
	if (NowCastConc < 0 or NowCastConc>300) then call missing (NowCastConc);
	where year =2021;
run; 
/*Calculates Medians wihtout extreme negative values*/
/*NowCastConc 25.25 AQI 79 RawConc = 25*/
proc means data=FA.Hanoi2021_clean n min max mean median;
run; 
/*Replacing missing with MEDIANS*/
proc stdize data=fa.hanoi2021_clean
	out=fa.hanoi2021_clean
	reponly method=median;
run;
proc means data=FA.Hanoi2021_clean n min max mean median;
run;

/*****************************************************************************************************/
/*MASTER DATASET!*/
data fa.hanoi_master;
	set fa.hanoi2016_clean;
	keep 	Site Parameter Date Year Month Day Hour AQI RawConc 
			ConcUnit Duration QCName AQICat NowCastConc;
run;
proc sql;
	insert into fa.hanoi_master(Site, Parameter, Date, Year, Month, Day, Hour, AQI,
				RawConc, ConcUnit, Duration, QCName, AQICat, NowCastConc)
	select Site, Parameter, Date, Year, Month, Day, Hour, AQI,
				RawConc, ConcUnit, Duration, QCName, AQICat, NowCastConc
	from fa.hanoi2017_clean;
quit;
proc sql;
	insert into fa.hanoi_master(Site, Parameter, Date, Year, Month, Day, Hour, AQI,
				RawConc, ConcUnit, Duration, QCName, AQICat, NowCastConc)
	select Site, Parameter, Date, Year, Month, Day, Hour, AQI,
				RawConc, ConcUnit, Duration, QCName, AQICat, NowCastConc
	from fa.hanoi2018_clean;
quit;
proc sql;
	insert into fa.hanoi_master(Site, Parameter, Date, Year, Month, Day, Hour, AQI,
				RawConc, ConcUnit, Duration, QCName, AQICat, NowCastConc)
	select Site, Parameter, Date, Year, Month, Day, Hour, AQI,
				RawConc, ConcUnit, Duration, QCName, AQICat, NowCastConc
	from fa.hanoi2019_clean;
quit;
proc sql;
	insert into fa.hanoi_master(Site, Parameter, Date, Year, Month, Day, Hour, AQI,
				RawConc, ConcUnit, Duration, QCName, AQICat, NowCastConc)
	select Site, Parameter, Date, Year, Month, Day, Hour, AQI,
				RawConc, ConcUnit, Duration, QCName, AQICat, NowCastConc
	from fa.hanoi2020_clean;
quit;
proc sql;
	insert into fa.hanoi_master(Site, Parameter, Date, Year, Month, Day, Hour, AQI,
				RawConc, ConcUnit, Duration, QCName, AQICat, NowCastConc)
	select Site, Parameter, Date, Year, Month, Day, Hour, AQI,
				RawConc, ConcUnit, Duration, QCName, AQICat, NowCastConc
	from fa.hanoi2021_clean;
quit;


ODS RTF FILE="/folders/myfolders/DANA/FA/2017_2021_stats.rtf" startpage=no;
ods graphics on;
ods noproctitle;
/*2017**************************************************************************************/
/*Original data set*/
title1 'Basic statistical descriptors';
title2 'Hanoi 2017 - original data';
proc means data=FA.Hanoi2017 n min max mean median;
run;

/*Restricting data plots before replacing with medians*/
title1 'Basic statistical descriptors';
title2 'Hanoi 2017 - restricted data';
proc means data=FA.Hanoi2017 n min max mean median;
	where (NowCastConc <150 and RawConc <300);
run;
/*Proc means after cleaning*/
title1 'Basic statistical descriptors';
title2 'Hanoi 2017 - clean data';
proc means data=FA.Hanoi2017_clean n min max mean median;
run;

/*2018**************************************************************************************/
/*Original data set*/
title1 'Basic statistical descriptors';
title2 'Hanoi 2018 - original data';
proc means data=FA.Hanoi2018 n min max mean median;
run;
/*Restricting data plots before replacing with medians*/
title1 'Basic statistical descriptors';
title2 'Hanoi 2018 - restricted data';
proc means data=FA.Hanoi2018 n min max mean median;
	where (NowCastConc <150 and RawConc <300);
run;
/*Proc means after cleaning*/
title1 'Basic statistical descriptors';
title2 'Hanoi 2018 - clean data';
proc means data=FA.Hanoi2018_clean n min max mean median;
run;

/*2019**************************************************************************************/
/*Original data set*/
title1 'Basic statistical descriptors';
title2 'Hanoi 2019 - original data';
proc means data=FA.Hanoi2019 n min max mean median;
run;
/*Restricting data plots before replacing with medians*/
title1 'Basic statistical descriptors';
title2 'Hanoi 2019 - restricted data';
proc means data=FA.Hanoi2019 n min max mean median;
	where (NowCastConc <150 and RawConc <300);
run;
/*Proc means after cleaning*/
title1 'Basic statistical descriptors';
title2 'Hanoi 2019 - clean data';
proc means data=FA.Hanoi2019_clean n min max mean median;
run;

/*2020**************************************************************************************/
/*Original data set*/
title1 'Basic statistical descriptors';
title2 'Hanoi 2020 - original data';
proc means data=FA.Hanoi2020 n min max mean median;
run;
/*Restricting data plots before replacing with medians*/
title1 'Basic statistical descriptors';
title2 'Hanoi 2020 - restricted data';
proc means data=FA.Hanoi2020 n min max mean median;
	where (NowCastConc <150 and RawConc <300);
run;
/*Proc means after cleaning*/
title1 'Basic statistical descriptors';
title2 'Hanoi 2020 - clean data';
proc means data=FA.Hanoi2020_clean n min max mean median;
run;

/*2021**************************************************************************************/
/*Original data set*/
title1 'Basic statistical descriptors';
title2 'Hanoi 2021 - original data';
proc means data=FA.Hanoi2021 n min max mean median;
run;
/*Restricting data plots before replacing with medians*/
title1 'Basic statistical descriptors';
title2 'Hanoi 2021 - restricted data';
proc means data=FA.Hanoi2021 n min max mean median;
	where (NowCastConc <150 and RawConc <300);
run;
/*Proc means after cleaning*/
title1 'Basic statistical descriptors';
title2 'Hanoi 2021 - clean data';
proc means data=FA.Hanoi2021_clean n min max mean median;
run;
ods rtf close;

/**********************************************************************************************/
/*Sorting out data*/
/*2017*/
proc sort data=fa.hanoi2017;
	by DAY;
run;
proc sort data=fa.hanoi2017_clean;
	by DAY;
run;
/*2018*/
proc sort data=fa.hanoi2018;
	by DAY;
run;
proc sort data=fa.hanoi2018_clean;
	by DAY;
run;
/*2019*/
proc sort data=fa.hanoi2019;
	by DAY;
run;
proc sort data=fa.hanoi2019_clean;
	by DAY;
run;
/*2020*/
proc sort data=fa.hanoi2020;
	by DAY;
run;
proc sort data=fa.hanoi2020_clean;
	by DAY;
run;
/*2021*/
proc sort data=fa.hanoi2021;
	by DAY;
run;
proc sort data=fa.hanoi2021_clean;
	by DAY;
run;

/*PLOTTING BOX PLOTS ***************************************************************************/
ODS RTF FILE="/folders/myfolders/DANA/FA/2017_2021_BOXPLOTS.rtf" startpage=no;
/*2017**********************************************/
/*BOX PLOT OF RAW DATA*/
title1 'Box Plot for NowCast';
title2 'Hanoi 2017 - before cleaning';
proc boxplot data=FA.Hanoi2017;
   plot NowCastConc*Day / boxstyle = schematic;
   inset min mean max stddev /
      header = 'Hanoi 2017 - before cleaning'
      pos    = tm;
   insetgroup min max /
      header = 'Raw Data';
run;
title;

/*BOX PLOT OF CLEAN DATA*/
title1 'Box Plot for NowCast';
title2 'Hanoi 2017 - after cleaning';
proc boxplot data=FA.Hanoi2017_clean;
   plot NowCastConc*Day / boxstyle = schematic;
   inset min mean max stddev /
      header = 'Hanoi 2017 - after cleaning'
      pos    = tm;
   insetgroup min max /
      header = 'Clean Data';
run;
title;
/*2018**********************************************/
/*BOX PLOT OF RAW DATA*/
title1 'Box Plot for NowCast';
title2 'Hanoi 2018 - before cleaning';
proc boxplot data=FA.Hanoi2018;
   plot NowCastConc*Day / boxstyle = schematic;
   inset min mean max stddev /
      header = 'Hanoi 2018 - before cleaning'
      pos    = tm;
   insetgroup min max /
      header = 'Raw Data';
run;
title;
/*BOX PLOT OF CLEAN DATA*/
title1 'Box Plot for NowCast';
title2 'Hanoi 2018 - after cleaning';
proc boxplot data=FA.Hanoi2018_clean;
   plot NowCastConc*Day / boxstyle = schematic;
   inset min mean max stddev /
      header = 'Hanoi 2018 - after cleaning'
      pos    = tm;
   insetgroup min max /
      header = 'Clean Data';
run;
title;
/*2019**********************************************/
/*BOX PLOT OF RAW DATA*/
title1 'Box Plot for NowCast';
title2 'Hanoi 2019 - before cleaning';
proc boxplot data=FA.Hanoi2019;
   plot NowCastConc*Day / boxstyle = schematic;
   inset min mean max stddev /
      header = 'Hanoi 2019 - before cleaning' 
      pos    = tm;
   insetgroup min max /
      header = 'Raw Data';
run;
title;
/*BOX PLOT OF CLEAN DATA*/
title1 'Box Plot for NowCast';
title2 'Hanoi 2019 - after cleaning';
proc boxplot data=FA.Hanoi2019_clean;
   plot NowCastConc*Day / boxstyle = schematic;
   inset min mean max stddev /
      header = 'Hanoi 2019 - after cleaning'
      pos    = tm;
   insetgroup min max /
      header = 'Clean Data';
run;
title;
/*2020**********************************************/
/*BOX PLOT OF RAW DATA*/
title1 'Box Plot for NowCast';
title2 'Hanoi 2020 - before cleaning';
proc boxplot data=FA.Hanoi2020;
   plot NowCastConc*Day / boxstyle = schematic;
   inset min mean max stddev /
      header = 'Hanoi 2020 - before cleaning'
      pos    = tm;
   insetgroup min max /
      header = 'Raw Data';
run;
title;
/*BOX PLOT OF CLEAN DATA*/
title1 'Box Plot for NowCast';
title2 'Hanoi 2020 - after cleaning';
proc boxplot data=FA.Hanoi2020_clean;
   plot NowCastConc*Day / boxstyle = schematic;
   inset min mean max stddev /
      header = 'Hanoi 2020 - after cleaning'
      pos    = tm;
   insetgroup min max /
      header = 'Clean Data';
run;
title;
/*2021**********************************************/
/*BOX PLOT OF RAW DATA*/
title1 'Box Plot for NowCast';
title2 'Hanoi 2021 - before cleaning';
proc boxplot data=FA.Hanoi2021;
   plot NowCastConc*Day / boxstyle = schematic;
   inset min mean max stddev /
      header = 'Hanoi 2021-  before cleaning'
      pos    = tm;
   insetgroup min max /
      header = 'Raw Data';
run;
title1 'Box Plot for NowCast';
title2 'Hanoi 2021 - after cleaning';
/*BOX PLOT OF CLEAN DATA*/
proc boxplot data=FA.Hanoi2021_clean;
   plot NowCastConc*Day / boxstyle = schematic;
   inset min mean max stddev /
      header = 'Hanoi 2021 - after cleaning'
      pos    = tm;
   insetgroup min max /
      header = 'Clean Data';
run;
title;
ods rtf close;


/*Export sample data*/

proc export data= fa.hanoi_master
			outfile= '/folders/myfolders/DANA/FA/Hanoi_Master_clean.csv'
			dbms =csv replace;
run;
proc export data= fa.hanoi2017_clean
			outfile= '/folders/myfolders/DANA/FA/Hanoi2017clean.csv'
			dbms =csv replace;
run;
proc export data= fa.hanoi2018_clean
			outfile= '/folders/myfolders/DANA/FA/Hanoi2018clean.csv'
			dbms =csv replace;
run;
proc export data= fa.hanoi2019_clean
			outfile= '/folders/myfolders/DANA/FA/Hanoi2019clean.csv'
			dbms =csv replace;
run;
proc export data= fa.hanoi2020_clean
			outfile= '/folders/myfolders/DANA/FA/Hanoi2020clean.csv'
			dbms =csv replace;
run;
proc export data= fa.hanoi2021_clean
			outfile= '/folders/myfolders/DANA/FA/Hanoi2021clean.csv'
			dbms =csv replace;
run;
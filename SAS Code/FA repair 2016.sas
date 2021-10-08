/*Final Assignment DANA - Ho Chi Minh database*/
/*Creates library for Final Assignment - FA*/
libname FA base "/folders/myfolders/DANA/FA";
/*from my folders in SAS server*/
run;

/*1. Importing data set of HANOI 2016 CSV*/
Data FA.Hanoi2016;
	infile '/folders/myfolders/DANA/FA/2016_12.csv' dlm=',' firstobs=2 missover;
	format Site $16. Parameter $17. Date_LT_ DATETIME13. Year 4. Month 2. Day 2. Hour 2. AQI 3.1 
			AQI_Category 1. _24_hr__Midpoint_Avg__Conc_ 5.1 Raw_Conc 3. Conc_Unit $5.
			Duration $4. QC_Name $10.;
		
	input Site Parameter Date_LT_:ANYDTDTM40. Year Month Day Hour AQI 
			AQI_Category $ _24_hr__Midpoint_Avg__Conc_ Raw_Conc Conc_Unit $
			Duration QC_Name $;
			
	rename 	Date_LT_=Date 
			AQI_Category=AQICatNum
			_24_hr__Midpoint_Avg__Conc_= _24hrMid 
			Raw_Conc=RawConc
			Conc_Unit= ConcUnit 
			QC_Name=QCName;
			
	put Date_LT_=DATETIME13.;
	options datestyle=dmy;
run;
proc SQL;
	alter table FA.Hanoi2016
		add AQICat char format=$30.
		add NowCastConc num format=8.
	;
quit;

/*Calculates NowCast for 2016*/
proc sort data=fa.hanoi2016;
	by year month day hour;
run;
data FA.Hanoi2016;

	set fa.hanoi2016;

	LagT1 = lag1(RawConc);
	LagT2 = lag2(RawConc);
	LagT3 = lag3(RawConc);
	LagT4 = lag4(RawConc);
	LagT5 = lag5(RawConc);
	LagT6 = lag6(RawConc);
	LagT7 = lag7(RawConc);
	LagT8 = lag8(RawConc);
	LagT9 = lag9(RawConc);
	LagT10 = lag10(RawConc);
	LagT11 = lag11(RawConc);
	
	min = min(of RawConc, LagT1, LagT2, LagT3, LagT4, LagT5, LagT6, LagT7, LagT8, LagT9, LagT10, LagT11);
	max = max(of RawConc, LagT1, LagT2, LagT3, LagT4, LagT5, LagT6, LagT7, LagT8, LagT9, LagT10, LagT11);
	
	if max = 0 then w_i = 0;
	else w_i = min/max;

	if w_i < 0.5 then
		w_star = 0.5;
	else if w_i => 0.5 then
		w_star = w_i;

	suma1 = w_star**11 + w_star**10 + w_star**9 + w_star**8 + w_star**7 + w_star** 6 + w_star**5 +
			w_star**4 + w_star**3 + w_star**2 + w_star**1+1;
			
	suma2 = RawConc+
			LagT1*w_star**1+
			LagT2*w_star**2+
			LagT3*w_star**3+
			lagT4*w_star**4+
			lagT5*w_star**5+
			LagT6*w_star**6+
			LagT7*w_star**7+
			LagT8*w_star**8+
			lagT9*w_star**9+
			lagT10*w_star**10+
			lagT11*w_star**11;
			
	result = suma2/suma1;
	
	NowCastConc = round(result,1);
	
	keep Site Parameter Date Year Month Day Hour AQI AQICatNum RawConc ConcUnit Duration 
			QCName AQICat NowCastConc;
run;

/*Calculates AQI Category for 2016*/
/*Sets the correct values of AQICat*/
data fa.hanoi2016;
	set fa.hanoi2016;
	
	if aqi <= 50 then 
		do;
			AQICat= "Good";
		end;
	else if aqi > 50 and aqi <=100 then
		do;
			AQICat= "Moderate";
		end;
	else if aqi > 100 and aqi <=150 then 
		do;
			AQICat = "Unhealthy for Sensitive Groups";
		end;
	else if aqi > 150 and aqi <=200 then 
		do;
			AQICat="Unhealthy"; 
		end;
	else if aqi > 200 and aqi <=300 then 
		do;
			AQICat="Very Unhealthy";
		end;
	else if aqi > 300 then 
		do;
			AQICat="Hazardous";
		end;
	where aqi>0 and RawConc >0 ;
	
	keep Site Parameter Date Year Month Day Hour AQI RawConc ConcUnit Duration 
			QCName AQICat NowCastConc;
run;

/*CALCULATING MEDIANS OF ALL VARIABLES TO REPLACE OUTLAYERS*/
title1 'Report of variables per value';
title2 'Hanoi 2016';
proc freq data = fa.hanoi2016 nlevels;
	tables RawConc AQI NowCastConc;
run;

ODS RTF FILE="/folders/myfolders/DANA/FA/2016_analysis.rtf" startpage=no;
ods noproctitle;
ods graphics on;

/*Calculates Medians wihtout extreme negative values*/
/* NOWCASTCONC = 38 RAWCONC=37*/
/*Original data set*/
title1 'Basic statistical descriptors';
title2 'Hanoi 2016 - original data';
proc means data=FA.Hanoi2016 n min max mean median;

run;
/*Restricting data plots before replacing with medians*/
title1 'Basic statistical descriptors';
title2 'Hanoi 2016 - restricted data';
proc means data=FA.Hanoi2016 n min max mean median;
	where (NowCastConc <150 and RawConc <300);
run;
/*OUT OF BOUDARIES REPLACED WITH MISSING STATUS*/
data fa.hanoi2016_clean;
	set fa.hanoi2016;
	if RawConc< 0 or RawConc > 300 then call missing (RawConc);
	if AQI < 0 or AQI > 300 then call missing (AQI);
	if NowCastConc < 0 or NowCastConc>150 then call missing (NowCastConc);
	where year=2016;
run; 
/*Replacing missing with MEDIANS*/
proc stdize data=fa.hanoi2016_clean
	out=fa.hanoi2016_clean
	reponly method=median;
run;

/*Proc means after cleaning*/
title1 'Basic statistical descriptors';
title2 'Hanoi 2016 - clean data';
proc means data=FA.Hanoi2016_clean n min max mean median;
run;
/*Sorting out data*/
proc sort data=fa.hanoi2016;
	BY DAY;
run;
proc sort data=fa.hanoi2016_clean;
	BY DAY;
run;
/*BOX PLOT OF RAW DATA*/
title1 'Box Plot for NowCast';
title2 'Hanoi 2016 - before cleaning';
proc boxplot data=FA.Hanoi2016;
   plot NowCastConc*Day / boxstyle = schematic;
   inset min mean max stddev /
      header = 'Hanoi 2016 - before cleaning'
      pos    = tm;
   insetgroup min max /
      header = 'Raw Data';
      /*refline 150/axis=ylineattrs=(thickness=2color=red)label="Unhealthy"*/;
run;
title;

title1 'Box Plot for AQI';
title2 'Hanoi 2016 - before cleaning';
proc boxplot data=FA.Hanoi2016;
   plot AQI*Day / boxstyle = schematic;
   inset min mean max stddev /
      header = 'Hanoi 2016 - before cleaning'
      pos    = tm;
   insetgroup min max /
      header = 'Raw Data';
      /*refline 150/axis=ylineattrs=(thickness=2color=red)label="Unhealthy"*/;
run;
title;

title1 'Box Plot for RawConc';
title2 'Hanoi 2016 - before cleaning';
proc boxplot data=FA.Hanoi2016;
   plot RawConc*Day / boxstyle = schematic;
   inset min mean max stddev /
      header = 'Hanoi 2016 - before cleaning'
      pos    = tm;
   insetgroup min max /
      header = 'Raw Data';
      /*refline 150/axis=ylineattrs=(thickness=2color=red)label="Unhealthy"*/;
run;
title;

/*BOX PLOTS OF CLEAN DATA*/

title1 'Box Plot for NowCast';
title2 'Hanoi 2016 - after cleaning';
proc boxplot data=FA.Hanoi2016_clean;
   plot NowCastConc*Day / boxstyle = schematic;
   inset min mean max stddev /
      header = 'Hanoi 2016 - after cleaning'
      pos    = tm;
   insetgroup min max /
      header = 'Clean Data';
      /*refline 150/axis=ylineattrs=(thickness=2color=red)label="Unhealthy"*/;
run;
title;

title1 'Box Plot for AQI';
title2 'Hanoi 2016 - before cleaning';
proc boxplot data=FA.Hanoi2016_clean;
   plot AQI*Day / boxstyle = schematic;
   inset min mean max stddev /
      header = 'Hanoi 2016 - after cleaning'
      pos    = tm;
   insetgroup min max /
      header = 'Clean Data';
      /*refline 150/axis=ylineattrs=(thickness=2color=red)label="Unhealthy"*/;
run;
title;

title1 'Box Plot for RawConc';
title2 'Hanoi 2016 - after cleaning';
proc boxplot data=FA.Hanoi2016_clean;
   plot RawConc*Day / boxstyle = schematic;
   inset min mean max stddev /
      header = 'Hanoi 2016 - after cleaning'
      pos    = tm;
   insetgroup min max /
      header = 'Clean Data';
      /*refline 150/axis=ylineattrs=(thickness=2color=red)label="Unhealthy"*/;
run;
title;

ods rtf close;

/*Export sample data*/
proc export data= fa.hanoi2016_clean
			outfile= '/folders/myfolders/DANA/FA/Hanoi2016clean.csv'
			dbms =csv replace;
run;




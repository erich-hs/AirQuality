/*************** External Data ***************/
/*************** Data Import ***************/
/************************************************** London **************************************************/
filename reffile '/folders/myfolders/DANA-4800/GroupProject/london-air-quality.csv';
proc import datafile=reffile
	dbms=csv
	out=FA.London;
	getnames=yes;
run;

data FA.London;
	set FA.London;
	keep date _pm10 _pm25 _co _no2 _o3 _so2 year month day dayofyear refperiod country;
	year = Year(date);
	month = Month(date);
	day = Day(date);
	dayofyear = put(date, date5.);
	country = 'London';
	if date >= '15MAR2020'D and date <= '11JUN2020'D
	or date >= '15MAR2019'D and date <= '11JUN2019'D then refperiod=1;
	else refperiod=0;
run;

/* checking for missing values */
proc univariate data=fa.london;
run;
/* _pm25 10 missing values */
/* _pm10 10 missing values */
/* _o3 46 missing values */
/* _no2 46 missing values */
/* _so2 202 missing values (7.66%) */
/* _co 66 missing values */

/* creating clean dataset, replacing missing values with yearly mean */
/* Clean London */
proc sort data=FA.London;
	by year;
run;
proc stdize data=FA.London out=FA.London_clean reponly missing=mean;
	var _numeric_;
	by year;
run;

/************************************************** Beijing **************************************************/
filename reffile '/folders/myfolders/DANA-4800/GroupProject/beijing-air-quality.csv';
proc import datafile=reffile
	dbms=csv
	out=FA.Beijing;
	getnames=yes;
run;

data FA.Beijing;
	set FA.Beijing;
	keep date _pm10 _pm25 _co _no2 _o3 _so2 year month day dayofyear refperiod country;
	year = Year(date);
	month = Month(date);
	day = Day(date);
	dayofyear = put(date, date5.);
	country = 'Beijing';
	if date >= '10FEB2020'D and date <= '15JUN2020'D
	or date >= '10FEB2019'D and date <= '15JUN2019'D then refperiod=1;
	else refperiod=0;
run;

proc univariate data=fa.beijing;
run;
/* _pm25 6 missing values */
/* _pm10 47 missing values */
/* _o3 16 missing values */
/* _no2 6 missing values */
/* _so2 304 missing values (11.55%) */
proc univariate data=fa.beijing;
	var _so2;
	where year=2019 or year=2020;
run;
/* _so2 234 missing values are on analysis period (32.05%) - will drop variables */
/* _co 66 missing values */

/* Clean Beijing */
proc sort data=FA.Beijing;
	by year;
run;
proc stdize data=FA.Beijing out=FA.Beijing_clean reponly missing=mean;
	var _numeric_;
	by year;
run;

/************************************************** Paris **************************************************/
filename reffile '/folders/myfolders/DANA-4800/GroupProject/paris-air-quality.csv';
proc import datafile=reffile
	dbms=csv
	out=FA.Paris;
	getnames=yes;
run;

data FA.Paris;
	set FA.Paris;
	keep date _pm10 _pm25 _co _no2 _o3 _so2 year month day dayofyear refperiod country;
	year = Year(date);
	month = Month(date);
	day = Day(date);
	dayofyear = put(date, date5.);
	country = 'Paris';
	if date >= '15MAR2020'D and date <= '18MAY2020'D
	or date >= '15MAR2019'D and date <= '18MAY2019'D then refperiod=1;
	else refperiod=0;
run;

proc univariate data=fa.paris;
run;
/* _pm25 8 missing values */
/* _pm10 8 missing values */
/* _o3 15 missing values */
/* _no2 8 missing values */

/* Clean Paris */
proc sort data=FA.Paris;
	by year;
run;
proc stdize data=FA.Paris out=FA.Paris_clean reponly missing=mean;
	var _numeric_;
	by year;
run;

/*********************************************** Scatterplots ***********************************************/
/************************************************************************************************************/
/************************************************** London **************************************************/
/************************************************************************************************************/
ODS RTF FILE="/folders/myfolders/DANA-4800/GroupProject/London.rtf" startpage=no;
ods graphics / reset width=16cm height=11cm imagemap;

/* PM2.5 */
proc sgplot data=FA.LONDON_clean;
	title height=12pt "London 2019 and 2020 PM2.5";
	styleattrs datacontrastcolors=(green blue);
	scatter x=date y=_pm25 / group=year markerattrs=(symbol=diamondfilled) transparency=0.25;
	xaxis grid;
	yaxis grid label="PM2.5";
	where year = 2019 or year = 2020;
	refline '15MAR2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RStart'	labelattrs=(color=red);
	refline '11JUN2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RRelief'	labelattrs=(color=red);
	refline '15MAR2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LStart'	labelattrs=(color=red);
	refline '11JUN2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LRelief'	labelattrs=(color=red);
run;

/* Reference period mean */
proc sgplot data=FA.LONDON_clean;
	title height=12pt "London reference periods 2019 and 2020 PM2.5";
	vbox _pm25 / category=year boxwidth=0.2 fillattrs=(color=CX3a81ec);
	where year = 2019 and refperiod = 1 or year = 2020 and refperiod = 1;
	yaxis grid label="PM2.5";
run;

proc means data=fa.london_clean mean;
	var _pm25;
	by year;
	where refperiod = 1;
run;

/* Test for normality */
proc univariate data=FA.LONDON_clean normal mu0=0;
	ods select TestsForNormality;
	class year;
	var _pm25;
	where refperiod = 1;
run;

/* t test */
proc ttest data=FA.LONDON_clean sides=2 h0=0 plots=none;
	class year;
	var _pm25;
	where refperiod = 1;
run;

/* PM10. */
proc sgplot data=FA.LONDON_clean;
	title height=12pt "London 2019 and 2020 PM10.";
	styleattrs datacontrastcolors=(green blue);
	scatter x=date y=_pm10 / group=year markerattrs=(symbol=diamondfilled) transparency=0.25;
	xaxis grid;
	yaxis grid label="PM10.";
	where year = 2019 or year = 2020;
	refline '15MAR2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RStart'	labelattrs=(color=red);
	refline '11JUN2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RRelief'	labelattrs=(color=red);
	refline '15MAR2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LStart'	labelattrs=(color=red);
	refline '11JUN2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LRelief'	labelattrs=(color=red);
run;

/* Reference period mean */
proc sgplot data=FA.LONDON_clean;
	title height=12pt "London reference periods 2019 and 2020 PM10.";
	vbox _pm10 / category=year boxwidth=0.2 fillattrs=(color=CX3a81ec);
	where year = 2019 and refperiod = 1 or year = 2020 and refperiod = 1;
	yaxis grid label="PM10.";
run;

proc means data=fa.london_clean mean;
	var _pm10;
	by year;
	where refperiod = 1;
run;

/* Test for normality */
proc univariate data=FA.LONDON_clean normal mu0=0;
	ods select TestsForNormality;
	class year;
	var _pm10;
	where refperiod = 1;
run;

/* t test */
proc ttest data=FA.LONDON_clean sides=2 h0=0 plots=none;
	class year;
	var _pm10;
	where refperiod = 1;
run;

/* NO2 */
proc sgplot data=FA.LONDON_clean;
	title height=12pt "London 2019 and 2020 NO2";
	styleattrs datacontrastcolors=(green blue);
	scatter x=date y=_no2 / group=year markerattrs=(symbol=diamondfilled) transparency=0.25;
	xaxis grid;
	yaxis grid label="NO2";
	where year = 2019 or year = 2020;
	refline '15MAR2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RStart'	labelattrs=(color=red);
	refline '11JUN2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RRelief'	labelattrs=(color=red);
	refline '15MAR2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LStart'	labelattrs=(color=red);
	refline '11JUN2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LRelief'	labelattrs=(color=red);
run;

/* Reference period mean */
proc sgplot data=FA.LONDON_clean;
	title height=12pt "London reference periods 2019 and 2020 NO2";
	vbox _no2 / category=year boxwidth=0.2 fillattrs=(color=CX3a81ec);
	where year = 2019 and refperiod = 1 or year = 2020 and refperiod = 1;
	yaxis grid label="NO2";
run;

proc means data=fa.london_clean mean;
	var _no2;
	by year;
	where refperiod = 1;
run;

/* Test for normality */
proc univariate data=FA.LONDON_clean normal mu0=0;
	ods select TestsForNormality;
	class year;
	var _no2;
	where refperiod = 1;
run;

/* t test */
proc ttest data=FA.LONDON_clean sides=2 h0=0 plots=none;
	class year;
	var _no2;
	where refperiod = 1;
run;

/* CO */
proc sgplot data=FA.LONDON_clean;
	title height=12pt "London 2019 and 2020 CO";
	styleattrs datacontrastcolors=(green blue);
	scatter x=date y=_co / group=year markerattrs=(symbol=diamondfilled) transparency=0.25;
	xaxis grid;
	yaxis grid label="CO";
	where year = 2019 or year = 2020;
	refline '15MAR2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RStart'	labelattrs=(color=red);
	refline '11JUN2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RRelief'	labelattrs=(color=red);
	refline '15MAR2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LStart'	labelattrs=(color=red);
	refline '11JUN2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LRelief'	labelattrs=(color=red);
run;

/* Reference period mean */
proc sgplot data=FA.LONDON_clean;
	title height=12pt "London reference periods 2019 and 2020 CO";
	vbox _co / category=year boxwidth=0.2 fillattrs=(color=CX3a81ec);
	where year = 2019 and refperiod = 1 or year = 2020 and refperiod = 1;
	yaxis grid label="CO";
run;

proc means data=fa.london_clean mean;
	var _co;
	by year;
	where refperiod = 1;
run;

/* Test for normality */
proc univariate data=FA.LONDON_clean normal mu0=0;
	ods select TestsForNormality;
	class year;
	var _co;
	where refperiod = 1;
run;

/* t test */
proc ttest data=FA.LONDON_clean sides=2 h0=0 plots=none;
	class year;
	var _co;
	where refperiod = 1;
run;

/* O3 */
proc sgplot data=FA.LONDON_clean;
	title height=12pt "London 2019 and 2020 O3";
	styleattrs datacontrastcolors=(green blue);
	scatter x=date y=_o3 / group=year markerattrs=(symbol=diamondfilled) transparency=0.25;
	xaxis grid;
	yaxis grid label="O3";
	where year = 2019 or year = 2020;
	refline '15MAR2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RStart'	labelattrs=(color=red);
	refline '11JUN2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RRelief'	labelattrs=(color=red);
	refline '15MAR2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LStart'	labelattrs=(color=red);
	refline '11JUN2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LRelief'	labelattrs=(color=red);
run;

/* Reference period mean */
proc sgplot data=FA.LONDON_clean;
	title height=12pt "London reference periods 2019 and 2020 O3";
	vbox _o3 / category=year boxwidth=0.2 fillattrs=(color=CX3a81ec);
	where year = 2019 and refperiod = 1 or year = 2020 and refperiod = 1;
	yaxis grid label="O3";
run;

proc means data=fa.london_clean mean;
	var _o3;
	by year;
	where refperiod = 1;
run;

/* Test for normality */
proc univariate data=FA.LONDON_clean normal mu0=0;
	ods select TestsForNormality;
	class year;
	var _o3;
	where refperiod = 1;
run;

/* t test */
proc ttest data=FA.LONDON_clean sides=2 h0=0 plots=none;
	class year;
	var _o3;
	where refperiod = 1;
run;

/* SO2 */
proc sgplot data=FA.LONDON_clean;
	title height=12pt "London 2019 and 2020 SO2";
	styleattrs datacontrastcolors=(green blue);
	scatter x=date y=_so2 / group=year markerattrs=(symbol=diamondfilled) transparency=0.25;
	xaxis grid;
	yaxis grid label="SO2";
	where year = 2019 or year = 2020;
	refline '15MAR2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RStart'	labelattrs=(color=red);
	refline '11JUN2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RRelief'	labelattrs=(color=red);
	refline '15MAR2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LStart'	labelattrs=(color=red);
	refline '11JUN2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LRelief'	labelattrs=(color=red);
run;

/* Reference period mean */
proc sgplot data=FA.LONDON_clean;
	title height=12pt "London reference periods 2019 and 2020 SO2";
	vbox _so2 / category=year boxwidth=0.2 fillattrs=(color=CX3a81ec);
	where year = 2019 and refperiod = 1 or year = 2020 and refperiod = 1;
	yaxis grid label="SO2";
run;

proc means data=fa.london_clean mean;
	var _co;
	by year;
	where refperiod = 1;
run;

/* Test for normality */
proc univariate data=FA.LONDON_clean normal mu0=0;
	ods select TestsForNormality;
	class year;
	var _co;
	where refperiod = 1;
run;

/* t test */
proc ttest data=FA.LONDON_clean sides=2 h0=0 plots=none;
	class year;
	var _co;
	where refperiod = 1;
run;

ods graphics / reset;
ods rtf close;
/*************************************************************************************************************/
/************************************************** Beijing **************************************************/
/*************************************************************************************************************/
ODS RTF FILE="/folders/myfolders/DANA-4800/GroupProject/Beijing.rtf" startpage=no;
ods graphics / reset width=16cm height=11cm imagemap;

/* PM2.5 */
proc sgplot data=FA.Beijing_clean;
	title height=12pt "Beijing 2019 and 2020 PM2.5";
	styleattrs datacontrastcolors=(green blue);
	scatter x=date y=_pm25 / group=year markerattrs=(symbol=diamondfilled) transparency=0.25;
	xaxis grid;
	yaxis grid label="PM2.5";
	where year = 2019 or year = 2020;
	refline '10FEB2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='Ref_Start'	labelattrs=(color=red);
	refline '15JUN2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='Ref_Relief'	labelattrs=(color=red);
	refline '10FEB2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='Lockd_Start'	labelattrs=(color=red);
	refline '15JUN2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='Lockd_Relief'	labelattrs=(color=red);
run;

/* Reference period mean */
proc sgplot data=FA.Beijing_clean;
	title height=12pt "Beijing reference periods 2019 and 2020 PM2.5";
	vbox _pm25 / category=year boxwidth=0.2 fillattrs=(color=CX3a81ec);
	where year = 2019 and refperiod = 1 or year = 2020 and refperiod = 1;
	yaxis grid label="PM2.5";
run;

proc means data=fa.beijing_clean mean;
	var _pm25;
	by year;
	where refperiod = 1;
run;

/* Test for normality */
proc univariate data=FA.beijing_clean normal mu0=0;
	ods select TestsForNormality;
	class year;
	var _pm25;
	where refperiod = 1;
run;

/* t test */
proc ttest data=FA.beijing_clean sides=2 h0=0 plots=none;
	class year;
	var _pm25;
	where refperiod = 1;
run;

/* PM10. */
proc sgplot data=FA.Beijing_clean;
	title height=12pt "Beijing 2019 and 2020 PM10.";
	styleattrs datacontrastcolors=(green blue);
	scatter x=date y=_pm10 / group=year markerattrs=(symbol=diamondfilled) transparency=0.25;
	xaxis grid;
	yaxis grid label="PM10.";
	where year = 2019 or year = 2020;
	refline '10FEB2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='Ref_Start'	labelattrs=(color=red);
	refline '15JUN2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='Ref_Relief'	labelattrs=(color=red);
	refline '10FEB2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='Lockd_Start'	labelattrs=(color=red);
	refline '15JUN2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='Lockd_Relief'	labelattrs=(color=red);
run;

/* Reference period mean */
proc sgplot data=FA.Beijing_clean;
	title height=12pt "Beijing reference periods 2019 and 2020 PM10.";
	vbox _pm10 / category=year boxwidth=0.2 fillattrs=(color=CX3a81ec);
	where year = 2019 and refperiod = 1 or year = 2020 and refperiod = 1;
	yaxis grid label="PM10.";
run;

proc means data=fa.beijing_clean mean;
	var _pm10;
	by year;
	where refperiod = 1;
run;

/* Test for normality */
proc univariate data=FA.beijing_clean normal mu0=0;
	ods select TestsForNormality;
	class year;
	var _pm10;
	where refperiod = 1;
run;

/* t test */
proc ttest data=FA.beijing_clean sides=2 h0=0 plots=none;
	class year;
	var _pm10;
	where refperiod = 1;
run;

/* NO2 */
proc sgplot data=FA.Beijing_clean;
	title height=12pt "Beijing 2019 and 2020 NO2";
	styleattrs datacontrastcolors=(green blue);
	scatter x=date y=_no2 / group=year markerattrs=(symbol=diamondfilled) transparency=0.25;
	xaxis grid;
	yaxis grid label="NO2";
	where year = 2019 or year = 2020;
	refline '10FEB2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='Ref_Start'	labelattrs=(color=red);
	refline '15JUN2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='Ref_Relief'	labelattrs=(color=red);
	refline '10FEB2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='Lockd_Start'	labelattrs=(color=red);
	refline '15JUN2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='Lockd_Relief'	labelattrs=(color=red);
run;

/* Reference period mean */
proc sgplot data=FA.Beijing_clean;
	title height=12pt "Beijing reference periods 2019 and 2020 NO2";
	vbox _no2 / category=year boxwidth=0.2 fillattrs=(color=CX3a81ec);
	where year = 2019 and refperiod = 1 or year = 2020 and refperiod = 1;
	yaxis grid label="NO2";
run;

proc means data=fa.beijing_clean mean;
	var _no2;
	by year;
	where refperiod = 1;
run;

/* Test for normality */
proc univariate data=FA.beijing_clean normal mu0=0;
	ods select TestsForNormality;
	class year;
	var _no2;
	where refperiod = 1;
run;

/* t test */
proc ttest data=FA.beijing_clean sides=2 h0=0 plots=none;
	class year;
	var _no2;
	where refperiod = 1;
run;

/* CO */
proc sgplot data=FA.Beijing_clean;
	title height=12pt "Beijing 2019 and 2020 CO";
	styleattrs datacontrastcolors=(green blue);
	scatter x=date y=_co / group=year markerattrs=(symbol=diamondfilled) transparency=0.25;
	xaxis grid;
	yaxis grid label="CO";
	where year = 2019 or year = 2020;
	refline '10FEB2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='Ref_Start'	labelattrs=(color=red);
	refline '15JUN2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='Ref_Relief'	labelattrs=(color=red);
	refline '10FEB2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='Lockd_Start'	labelattrs=(color=red);
	refline '15JUN2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='Lockd_Relief'	labelattrs=(color=red);
run;

/* Reference period mean */
proc sgplot data=FA.Beijing_clean;
	title height=12pt "Beijing reference periods 2019 and 2020 CO";
	vbox _co / category=year boxwidth=0.2 fillattrs=(color=CX3a81ec);
	where year = 2019 and refperiod = 1 or year = 2020 and refperiod = 1;
	yaxis grid label="CO";
run;

proc means data=fa.beijing_clean mean;
	var _co;
	by year;
	where refperiod = 1;
run;

/* Test for normality */
proc univariate data=FA.beijing_clean normal mu0=0;
	ods select TestsForNormality;
	class year;
	var _co;
	where refperiod = 1;
run;

/* t test */
proc ttest data=FA.beijing_clean sides=2 h0=0 plots=none;
	class year;
	var _co;
	where refperiod = 1;
run;

/* O3 */
proc sgplot data=FA.Beijing_clean;
	title height=12pt "Beijing 2019 and 2020 O3";
	styleattrs datacontrastcolors=(green blue);
	scatter x=date y=_o3 / group=year markerattrs=(symbol=diamondfilled) transparency=0.25;
	xaxis grid;
	yaxis grid label="O3";
	where year = 2019 or year = 2020;
	refline '10FEB2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='Ref_Start'	labelattrs=(color=red);
	refline '15JUN2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='Ref_Relief'	labelattrs=(color=red);
	refline '10FEB2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='Lockd_Start'	labelattrs=(color=red);
	refline '15JUN2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='Lockd_Relief'	labelattrs=(color=red);
run;

/* Reference period mean */
proc sgplot data=FA.Beijing_clean;
	title height=12pt "Beijing reference periods 2019 and 2020 O3";
	vbox _o3 / category=year boxwidth=0.2 fillattrs=(color=CX3a81ec);
	where year = 2019 and refperiod = 1 or year = 2020 and refperiod = 1;
	yaxis grid label="O3";
run;

proc means data=fa.beijing_clean mean;
	var _o3;
	by year;
	where refperiod = 1;
run;

/* Test for normality */
proc univariate data=FA.beijing_clean normal mu0=0;
	ods select TestsForNormality;
	class year;
	var _o3;
	where refperiod = 1;
run;

/* t test */
proc ttest data=FA.beijing_clean sides=2 h0=0 plots=none;
	class year;
	var _o3;
	where refperiod = 1;
run;

/* SO2 */
/* dropped due to > 32% missing data */

ods graphics / reset;
ods rtf close;
/***********************************************************************************************************/
/************************************************** Paris **************************************************/
/***********************************************************************************************************/
ODS RTF FILE="/folders/myfolders/DANA-4800/GroupProject/Paris.rtf" startpage=no;
ods graphics / reset width=16cm height=11cm imagemap;

/* PM2.5 */
proc sgplot data=FA.Paris_clean;
	title height=12pt "Paris 2019 and 2020 PM2.5";
	styleattrs datacontrastcolors=(green blue);
	scatter x=date y=_pm25 / group=year markerattrs=(symbol=diamondfilled) transparency=0.25;
	xaxis grid;
	yaxis grid label="PM2.5";
	where year = 2019 or year = 2020;
	refline '15MAR2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RStart'	labelattrs=(color=red);
	refline '18MAY2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RRelief'	labelattrs=(color=red);
	refline '15MAR2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LStart'	labelattrs=(color=red);
	refline '18MAY2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LRelief'	labelattrs=(color=red);
run;

/* Reference period mean */
proc sgplot data=FA.Paris_clean;
	title height=12pt "Paris reference periods 2019 and 2020 PM2.5";
	vbox _pm25 / category=year boxwidth=0.2 fillattrs=(color=CX3a81ec);
	where year = 2019 and refperiod = 1 or year = 2020 and refperiod = 1;
	yaxis grid label="PM2.5";
run;

proc means data=fa.Paris_clean mean;
	var _pm25;
	by year;
	where refperiod = 1;
run;

/* Test for normality */
proc univariate data=FA.Paris_clean normal mu0=0;
	ods select TestsForNormality;
	class year;
	var _pm25;
	where refperiod = 1;
run;

/* t test */
proc ttest data=FA.Paris_clean sides=2 h0=0 plots=none;
	class year;
	var _pm25;
	where refperiod = 1;
run;

/* PM10. */
proc sgplot data=FA.Paris_clean;
	title height=12pt "Paris 2019 and 2020 PM10.";
	styleattrs datacontrastcolors=(green blue);
	scatter x=date y=_pm10 / group=year markerattrs=(symbol=diamondfilled) transparency=0.25;
	xaxis grid;
	yaxis grid label="PM10.";
	where year = 2019 or year = 2020;
	refline '15MAR2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RStart'	labelattrs=(color=red);
	refline '18MAY2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RRelief'	labelattrs=(color=red);
	refline '15MAR2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LStart'	labelattrs=(color=red);
	refline '18MAY2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LRelief'	labelattrs=(color=red);
run;

/* Reference period mean */
proc sgplot data=FA.Paris_clean;
	title height=12pt "Paris reference periods 2019 and 2020 PM10.";
	vbox _pm10 / category=year boxwidth=0.2 fillattrs=(color=CX3a81ec);
	where year = 2019 and refperiod = 1 or year = 2020 and refperiod = 1;
	yaxis grid label="PM10.";
run;

proc means data=fa.Paris_clean mean;
	var _pm10;
	by year;
	where refperiod = 1;
run;

/* Test for normality */
proc univariate data=FA.Paris_clean normal mu0=0;
	ods select TestsForNormality;
	class year;
	var _pm10;
	where refperiod = 1;
run;

/* t test */
proc ttest data=FA.Paris_clean sides=2 h0=0 plots=none;
	class year;
	var _pm10;
	where refperiod = 1;
run;

/* NO2 */
proc sgplot data=FA.Paris_clean;
	title height=12pt "Paris 2019 and 2020 NO2";
	styleattrs datacontrastcolors=(green blue);
	scatter x=date y=_no2 / group=year markerattrs=(symbol=diamondfilled) transparency=0.25;
	xaxis grid;
	yaxis grid label="NO2";
	where year = 2019 or year = 2020;
	refline '15MAR2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RStart'	labelattrs=(color=red);
	refline '18MAY2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RRelief'	labelattrs=(color=red);
	refline '15MAR2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LStart'	labelattrs=(color=red);
	refline '18MAY2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LRelief'	labelattrs=(color=red);
run;

/* Reference period mean */
proc sgplot data=FA.Paris_clean;
	title height=12pt "Paris reference periods 2019 and 2020 NO2";
	vbox _no2 / category=year boxwidth=0.2 fillattrs=(color=CX3a81ec);
	where year = 2019 and refperiod = 1 or year = 2020 and refperiod = 1;
	yaxis grid label="NO2";
run;

proc means data=fa.Paris_clean mean;
	var _no2;
	by year;
	where refperiod = 1;
run;

/* Test for normality */
proc univariate data=FA.Paris_clean normal mu0=0;
	ods select TestsForNormality;
	class year;
	var _no2;
	where refperiod = 1;
run;

/* t test */
proc ttest data=FA.Paris_clean sides=2 h0=0 plots=none;
	class year;
	var _no2;
	where refperiod = 1;
run;

/* CO */
/* Not enough data */

/* O3 */
proc sgplot data=FA.Paris_clean;
	title height=12pt "Paris 2019 and 2020 O3";
	styleattrs datacontrastcolors=(green blue);
	scatter x=date y=_o3 / group=year markerattrs=(symbol=diamondfilled) transparency=0.25;
	xaxis grid;
	yaxis grid label="O3";
	where year = 2019 or year = 2020;
	refline '15MAR2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RStart'	labelattrs=(color=red);
	refline '18MAY2019'D / axis=x lineattrs=(thickness=2 color=red)
	label='RRelief'	labelattrs=(color=red);
	refline '15MAR2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LStart'	labelattrs=(color=red);
	refline '18MAY2020'D / axis=x lineattrs=(thickness=2 color=red)
	label='LRelief'	labelattrs=(color=red);
run;

/* Reference period mean */
proc sgplot data=FA.Paris_clean;
	title height=12pt "Paris reference periods 2019 and 2020 O3";
	vbox _o3 / category=year boxwidth=0.2 fillattrs=(color=CX3a81ec);
	where year = 2019 and refperiod = 1 or year = 2020 and refperiod = 1;
	yaxis grid label="O3";
run;

proc means data=fa.Paris_clean mean;
	var _o3;
	by year;
	where refperiod = 1;
run;

/* Test for normality */
proc univariate data=FA.Paris_clean normal mu0=0;
	ods select TestsForNormality;
	class year;
	var _o3;
	where refperiod = 1;
run;

/* t test */
proc ttest data=FA.Paris_clean sides=2 h0=0 plots=none;
	class year;
	var _o3;
	where refperiod = 1;
run;

/* SO2 */
/* Not enough data */

ods graphics / reset;
ods rtf close;

/********************************************** Global Analysis **********************************************/
proc sql;
	create table FA.Global as
	select date, year, _pm10, _pm25, _no2, refperiod, country from FA.London_clean
	where refperiod=1
	union
	select date, year, _pm10, _pm25, _no2, refperiod, country from FA.Beijing_clean
	where refperiod=1
	union
	select date, year, _pm10, _pm25, _no2, refperiod, country from FA.Paris_clean
	where refperiod=1
	;
quit;

proc means data=fa.global;
	where year=2020;
run;
/* Boxplots */
/* NO2 */
ODS RTF FILE="/folders/myfolders/DANA-4800/GroupProject/Global.rtf" startpage=no;
ods graphics / reset width=14cm height=10cm imagemap;
proc sgplot data=FA.Global;
	title height=12pt "Reference vs Lockdown periods NO2";
	vbox _no2 / category=country group=year boxwidth=0.3 groupdisplay=cluster;
	yaxis grid label="NO2";
run;

/* PM 2.5 */
proc sgplot data=FA.Global;
	title height=12pt "Reference vs Lockdown periods PM2.5";
	vbox _pm25 / category=country group=year boxwidth=0.3 groupdisplay=cluster;
	yaxis grid label="PM2.5";
run;

/* PM 10. */
proc sgplot data=FA.Global;
	title height=12pt "Reference vs Lockdown periods PM10.";
	vbox _pm10 / category=country group=year boxwidth=0.3 groupdisplay=cluster;
	yaxis grid label="PM10.";
run;
ods graphics / reset;
ods rtf close;
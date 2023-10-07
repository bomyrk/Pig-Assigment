--1.)  Find out the top 5 most visited destinations.

--A = load 'input/flights_details.csv' USING PigStorage(',')  AS
A = load 'Documents/flights_details.csv' USING PigStorage(',')
AS (
id:int,
year:int,
month:int,
DayofMonth:int,
DayOfWeek:int,
DepTime:int,
CRSDepTime:int,
ArrTime:int,
CRSArrTime:int,
UniqueCarrier:chararray,
FlightNum:int,
TailNum:chararray,
ActualElapsedTime:int,
CRSElapsedTime:int,
AirTime:int,
ArrDelay:int,
DepDelay:int,
Origin:chararray,
Dest:chararray,
Distance:int,
Taxiln:int,
TaxiOut:int,
Cancelled:int,
CancellationCode:chararray,
Diverted:int,
CarrierDelay:int,
WeatherDelay:int,
NASDelay:int,
SecurityDelay:int
);
B = foreach A GENERATE year, FlightNum, Origin, Dest;
C = DISTINCT B;
D = FILTER C BY Dest IS NOT NULL;
E = GROUP D BY Dest;
F = FOREACH E GENERATE group, COUNT(D.Dest);
G = ORDER F BY $1 DESC;
H = LIMIT G 5;

AR = load 'Documents/airports.csv' USING PigStorage(',')
AS (
Dest:chararray,
NameAirport:chararray,
City:chararray,
State:chararray,
Country:chararray,
Lag:int,
Long:int);
BR = foreach AR GENERATE Dest, City, Country;
CR = JOIN H BY $0, BR BY Dest;
DR = ORDER CR BY $1 DESC ;
DUMP DR;

--(LAS,93,LAS,Graham,USA)
--(LAS,93,LAS,Whiteriver,USA)
--(LAS,93,LAS,Wickenburg,USA)
--(LAS,93,LAS,Jal,USA)
--(LAS,93,LAS,Enterprise,USA)
--(LAS,93,LAS,Dyersburg,USA)
--(LAS,93,LAS,Meeker,USA)
--(LAS,93,LAS,Keene,USA)
--(LAS,93,LAS,Eek,USA)
--(LAS,93,LAS,Needles,USA)
--(LAS,93,LAS,Gruver,USA)
--(LAS,93,LAS,Douglas Bisbee,USA)
--(LAS,93,LAS,Duluth,USA)
--(LAS,93,LAS,Monahans,USA)
--(LAS,93,LAS,Eunice,USA)
--(LAS,93,LAS,Hatch,USA)
--(LAS,93,LAS,Lovington,USA)
--(LAS,93,LAS,Tatum,USA)
--(LAS,93,LAS,Andrews,USA)
--(MDW,79,MDW,South Sioux City,USA)
--(MDW,79,MDW,Skagway,USA)
--(MDW,79,MDW,Mount Ida,USA)
--(MDW,79,MDW,McGehee,USA)
--(MDW,79,MDW,Tatitlek,USA)
--(MDW,79,MDW,Osceola,USA)
--(MDW,79,MDW,Hartford,USA)
--(PHX,78,PHX,Freehold,USA)
--(PHX,78,PHX,Lindsay,USA)
--(PHX,78,PHX,Goldsby,USA)
--(PHX,78,PHX,Delphi,USA)
--(PHX,78,PHX,Bonifay,USA)
--(BWI,65,BWI,Hudson,USA)
--(BWI,65,BWI,Fair Haven,USA)
--(BWI,65,BWI,Baltimore,USA)
--(OAK,62,OAK,Hilliard,USA)
--(OAK,62,OAK,Gatesville,USA)
--(OAK,62,OAK,Griffith,USA)
--(OAK,62,OAK,Clanton,USA)
--(OAK,62,OAK,Belmont,USA)



--2.) Which month has seen the most number of cancellations due to bad weather?


--A = load 'input/flights_details.csv' USING PigStorage(',')  AS
A = load 'Documents/flights_details.csv' USING PigStorage(',')
AS (
id:int,
year:int,
month:int,
DayofMonth:int,
DayOfWeek:int,
DepTime:int,
CRSDepTime:int,
ArrTime:int,
CRSArrTime:int,
UniqueCarrier:chararray,
FlightNum:int,
TailNum:chararray,
ActualElapsedTime:int,
CRSElapsedTime:int,
AirTime:int,
ArrDelay:int,
DepDelay:int,
Origin:chararray,
Dest:chararray,
Distance:int,
Taxiln:int,
TaxiOut:int,
Cancelled:int,
CancellationCode:chararray,
Diverted:int,
CarrierDelay:int,
WeatherDelay:int,
NASDelay:int,
SecurityDelay:int
);
B = foreach A GENERATE month, FlightNum, Cancelled, CancellationCode;
C = DISTINCT B;
D = FILTER C BY Cancelled == 1 AND CancellationCode == 'B';
E = GROUP D BY month;
F = FOREACH E GENERATE group, COUNT(D.Cancelled);
G = ORDER F BY $1 DESC;
H = LIMIT G 1;

DUMP H;

--(1,60)


--3.) Top ten origins with the highest AVG departure delay

--A = load 'input/flights_details.csv' USING PigStorage(',')  AS
A = load 'Documents/flights_details.csv' USING PigStorage(',')
AS (
id:int,
year:int,
month:int,
DayofMonth:int,
DayOfWeek:int,
DepTime:int,
CRSDepTime:int,
ArrTime:int,
CRSArrTime:int,
UniqueCarrier:chararray,
FlightNum:int,
TailNum:chararray,
ActualElapsedTime:int,
CRSElapsedTime:int,
AirTime:int,
ArrDelay:int,
DepDelay:int,
Origin:chararray,
Dest:chararray,
Distance:int,
Taxiln:int,
TaxiOut:int,
Cancelled:int,
CancellationCode:chararray,
Diverted:int,
CarrierDelay:int,
WeatherDelay:int,
NASDelay:int,
SecurityDelay:int
);
B = foreach A GENERATE DepDelay, Origin;
D = FILTER B BY (DepDelay IS NOT NULL) AND (Origin IS NOT NULL);
E = GROUP D BY Origin;
F = FOREACH E GENERATE group, AVG(D.DepDelay);
G = ORDER F BY $1 DESC;
H = LIMIT G 10;

AR = load 'Documents/airports.csv' USING PigStorage(',')
AS (
Org:chararray,
NameAirport:chararray,
City:chararray,
State:chararray,
Country:chararray,
Lag:int,
Long:int);
BR = foreach AR GENERATE Org, City, Country;
CR = JOIN BR BY Org, H BY $0;
DR = FOREACH CR GENERATE $0, $1, $2, $4;
ER = ORDER DR BY $3 DESC ;
DUMP ER;


--(MDW,South Sioux City,USA,48.950980392156865)
--(MDW,Tatitlek,USA,48.950980392156865)
--(MDW,McGehee,USA,48.950980392156865)
--(MDW,Mount Ida,USA,48.950980392156865)
--(MDW,Skagway,USA,48.950980392156865)
--(MDW,Osceola,USA,48.950980392156865)
--(MDW,Hartford,USA,48.950980392156865)
--(LAS,Dyersburg,USA,41.830601092896174)
--(LAS,Douglas Bisbee,USA,41.830601092896174)
--(LAS,Duluth,USA,41.830601092896174)
--(LAS,Monahans,USA,41.830601092896174)
--(LAS,Eunice,USA,41.830601092896174)
--(LAS,Hatch,USA,41.830601092896174)
--(LAS,Lovington,USA,41.830601092896174)
--(LAS,Tatum,USA,41.830601092896174)
--(LAS,Andrews,USA,41.830601092896174)
--(LAS,Graham,USA,41.830601092896174)
--(LAS,Gruver,USA,41.830601092896174)
--(LAS,Whiteriver,USA,41.830601092896174)
--(LAS,Wickenburg,USA,41.830601092896174)
--(LAS,Jal,USA,41.830601092896174)
--(LAS,Enterprise,USA,41.830601092896174)
--(LAS,Needles,USA,41.830601092896174)
--(LAS,Eek,USA,41.830601092896174)
--(LAS,Keene,USA,41.830601092896174)
--(LAS,Meeker,USA,41.830601092896174)
--(OAK,Clanton,USA,41.294117647058826)
--(OAK,Belmont,USA,41.294117647058826)
--(OAK,Hilliard,USA,41.294117647058826)
--(OAK,Gatesville,USA,41.294117647058826)
--(OAK,Griffith,USA,41.294117647058826)


--4.) Which route (origin & destination) has seen the maximum diversion?

A = load 'Documents/flights_details.csv' USING PigStorage(',')
AS (
id:int,
year:int,
month:int,
DayofMonth:int,
DayOfWeek:int,
DepTime:int,
CRSDepTime:int,
ArrTime:int,
CRSArrTime:int,
UniqueCarrier:chararray,
FlightNum:int,
TailNum:chararray,
ActualElapsedTime:int,
CRSElapsedTime:int,
AirTime:int,
ArrDelay:int,
DepDelay:int,
Origin:chararray,
Dest:chararray,
Distance:int,
Taxiln:int,
TaxiOut:int,
Cancelled:int,
CancellationCode:chararray,
Diverted:int,
CarrierDelay:int,
WeatherDelay:int,
NASDelay:int,
SecurityDelay:int
);
B = foreach A GENERATE Origin, Dest, Diverted;
D = FILTER B BY (Origin IS NOT NULL) AND (Dest IS NOT NULL) AND (Diverted == 1) ;
E = GROUP D BY (Origin, Dest);
F = FOREACH E GENERATE group, COUNT(D.Diverted);
G = ORDER F BY $1 DESC;
H = LIMIT G 10;

--((MDW,HOU),6)
--((MCO,BWI),6)
--((MDW,FLL),5)
--((MDW,IAD),4)
--((MCO,BHM),3)
--((MCO,BNA),3)
--((MCI,TUL),3)
--((MCI,STL),3)
--((MCO,BUF),2)
--((MCO,DTW),2)








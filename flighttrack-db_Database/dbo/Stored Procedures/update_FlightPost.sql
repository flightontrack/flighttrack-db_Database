CREATE PROCEDURE [dbo].[update_FlightPost]
AS
UPDATE t1 SET AirportCode = t2.code,IsGeocoded = 1
FROM GpsLocation t1
JOIN AirportCoordinates t2 
ON GeoLocbuffer.STIntersects(t1.GeoLocation)=1 
WHERE IsGeocoded = 0 AND ABS(t1.AltitudeFt-t2.AltDecimal) <200

;WITH WQ1 AS (
SELECT FlightId,AirportCode,GpsLocationID,r=row_number() over(partition by  FlightId,AirportCode order by GpsLocationID ) 
FROM [dbo].[GpsLocation] WHERE  AirportCode IS NOT NULL --AND FlightID = 125
),
WQ2 AS (
SELECT FlightId,AirportCode,rn =ROW_NUMBER() OVER(PARTITION BY  FlightId ORDER BY GpsLocationID )
FROM WQ1 WHERE r=1
),
WQ3 AS(
SELECT FlightId,Q3.name
FROM WQ2 Q4
OUTER APPLY (SELECT DISTINCT  name=STUFF((SELECT '-' + AirportCode FROM WQ2 WHERE FlightId=Q4.FlightId ORDER BY rn,AirportCode FOR XML PATH('')) , 1, 1, '' )) Q3
)
UPDATE t1 SET  FlightName = ISNULL(t2.name,t1.FlightID),IsNameUpdated=1
--SELECT t1.FlightId,FlightName ,t2.name
FROM Flight t1
JOIN WQ3 t2 ON t2.FlightID = t1.FlightId
WHERE IsNameUpdated IS NULL

UPDATE t1 SET  FlightDurationMin = t2.flightdur,FlightTimeStart = t2.StartTime
FROM Flight t1
OUTER APPLY (SELECT flightdur=DATEDIFF(mi,min(gpstime),MAX(gpstime)),StartTime=MIN(gpstime) FROM [dbo].[GpsLocation] WHERE FlightId = t1.FlightId) t2
WHERE FlightDurationMin IS NULL
CREATE PROCEDURE [dbo].[update_FlightStatus]
@FlightID INT=NULL, @FlightStateID INT=NULL
AS
SET NOCOUNT ON

BEGIN TRY

IF @FlightStateID = 4 
/* if Flight Ended/Closed  */
BEGIN

UPDATE t1 SET AirportCode = t2.code, IsGeocoded = 1
FROM GpsLocation t1
JOIN AirportCoordinates t2 
ON GeoLocbuffer.STIntersects(t1.GeoLocation)=1
WHERE t1.FlightID=@FlightID AND ABS(t1.AltitudeFt-t2.AltDecimal) <200

;WITH WQ1 AS (
SELECT FlightId,AirportCode,GpsLocationID,r=row_number() over(partition by  FlightId,AirportCode order by GpsLocationID ) 
FROM [dbo].[GpsLocation] WHERE  AirportCode IS NOT NULL AND FlightID = @FlightID
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
UPDATE t1 SET  FlightName = ISNULL(t2.name,t1.FlightID),IsNameUpdated=1--,IsJunk=IIF(Points<=1,1,0) 
FROM Flight t1
LEFT JOIN WQ3 t2 ON t2.FlightID = t1.FlightId
WHERE t1.FlightID=@FlightID

UPDATE t1 SET FlightStateID=@FlightStateID, FlightDurationMin = t2.flightdur,FlightTimeStart = t2.StartTime,Updated=getdate()--,IsJunk=IIF(Points<=1,1,0) 
FROM Flight t1
OUTER APPLY (SELECT flightdur=DATEDIFF(mi,min(gpstime),MAX(gpstime)),StartTime=MIN(gpstime) FROM [dbo].[GpsLocation] WHERE FlightId = t1.FlightId) t2
WHERE FlightID=@FlightID
END

ELSE
BEGIN
 UPDATE t1
 SET FlightStateID=@FlightStateID,Updated=getdate()--,IsJunk=IIF(@FlightStateID>2,0,1) 
 FROM Flight t1
 WHERE FlightID=@FlightID
END

RETURN 0
END TRY
BEGIN CATCH
 DECLARE @ERRMSG VARCHAR(1024)= (SELECT ERROR_MESSAGE())
 INSERT INTO [dbo].[AppLog]
           ([Created]
           ,[Msg]
           ,[MsgType])
     VALUES (
           GETDATE()
           ,@ERRMSG
           ,'ERROR')
 SELECT responseType=-1,response=0
 RAISERROR(@ERRMSG,16,1)
 RETURN -1
END CATCH
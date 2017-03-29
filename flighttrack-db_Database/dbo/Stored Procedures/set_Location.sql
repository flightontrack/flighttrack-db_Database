CREATE PROCEDURE [dbo].[set_Location]
	@flightid		NVARCHAR(50),
	@flightControllerID INT = NULL,
	@latitude		NVARCHAR(50),
	@longitude		NVARCHAR(50),
	@speed			NVARCHAR(50) = -1,
	@date			NVARCHAR(50) = NULL,
	@accuracy		NVARCHAR(50) = NULL,
	@eventType		NVARCHAR(50) = NULL,
	@extraInfo		NVARCHAR(255) = NULL,
	@wpntnum		NVARCHAR(10) = NULL,
	@signalstrength	NVARCHAR(10) = NULL
AS

SET NOCOUNT ON;
DECLARE 
	@g geography, 
	@FlightStart_GPSLocationID INT = -1,
	@isPattern BIT = 0,
	@flightState VARCHAR(20),
	@rc INT = -1,
	@DATATYPE_ACKN INT = 3;

BEGIN TRY

IF NOT EXISTS(SELECT 1 FROM GpsLocation WHERE FlightID = @flightid AND onSessionPointNum=@wpntnum)
BEGIN
	INSERT INTO GpsLocation (
		Latitude, 
		Longitude 
		--,speed
		,gpsTime 
		,accuracy 
		,extraInfo
		,FlightID
		,onSessionPointNum
		,GeoLocation
		,SpeedMpC
		,signalstrength
		,AltitudeFt
	)
	--OUTPUT INSERTED.GPSLocationID INTO
	VALUES (
		@latitude
		,@longitude 
		--,round(@speed,0,1) 
		,@date 
		,round(@accuracy,0,1)  
		,round(@extraInfo,2)
		,@flightid
		,@wpntnum --(SELECT COUNT(*)+1 FROM GpsLocation WHERE FlightID=@flightid)
		,geography::Point(@latitude,@longitude, 4326)
		,round(@speed,0,1)
		,CAST(@signalstrength AS INT)
		,FLOOR(CONVERT([decimal],@extraInfo,(0))*(3.281))
	)
	DECLARE @GPSLocationID INT = IDENT_CURRENT('dbo.GpsLocation') 
	
	--SELECT @g = geography::Point(GeoLocation.Lat,GeoLocation.Long, 4326) FROM GpsLocation WHERE GPSLocationID = @FlightStart_GPSLocationID
	--UPDATE GpsLocation set DistanceToStartPoint = @g.STDistance(GeoLocation) WHERE GPSLocationID = @GPSLocationID
		
	UPDATE t1 SET 
	FlightStart_GPSLocationID = IIF(@rc =  0,ISNULL(FlightStart_GPSLocationID,@GPSLocationID),FlightStart_GPSLocationID),
	Last_GPSLocationID=@GPSLocationID,
	Points = @wpntnum,
	Updated=GETDATE(),
	FlightTimeStart = t2.StartTime
	FROM Flight t1
	OUTER APPLY (SELECT StartTime=MIN(lastUpdate) FROM [dbo].[GpsLocation] WHERE FlightId = t1.FlightId) t2
	WHERE FlightID=@flightid

END

UPDATE FlightController SET r_ResponseData = @wpntnum,Updated=getdate() --, r_ResponseType = @DATATYPE_ACKN -- response datatype = acknolegment
WHERE FlightControllerID = @flightControllerID
--AND r_ResponseType = @DATATYPE_ACKN --- update if response type is 'ackn'

RETURN 0
END TRY
BEGIN CATCH
	--THROW;
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
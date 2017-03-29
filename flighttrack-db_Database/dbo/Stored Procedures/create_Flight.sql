CREATE PROCEDURE [dbo].[create_Flight]
	@Pilotid INT = NULL,
	@AcftMake VARCHAR(50) = NULL,
	@AcftModel VARCHAR(50) = NULL,
	@AcftSeries VARCHAR(50) = NULL,
	@AcftNum VARCHAR(50) = NULL,
	@AcftTagId VARCHAR(50) = NULL,
	@AcftName VARCHAR(100) = NULL,
	@isFlyingPattern INT = 0,
	@FlightControllerID INT,
	@SpeedThreshhold INT,
	@Freq INT,
	@Routeid VARCHAR(50) = NULL,
	@VersionCode INT = NULL
AS

SET NOCOUNT ON

BEGIN TRY

DECLARE @ap_id INT
EXEC @ap_id = create_Aicraft @AcftNum,@AcftTagId,@AcftName,@Pilotid

DECLARE @responseType CHAR(1) = '0';

INSERT INTO Flight (
	AcftID,
	PilotID,
	AcftPilotID,
	isPattern,
	IsShared,
	FlightStateID,
	FlightControllerID,
	Points,
	SpeedThreshhold,
	AppVersionCode,
	FreqSec
)
--OUTPUT @responseType AS responseType, INSERTED.FlightID AS response
SELECT 
	(SELECT TOP 1 AcftID FROM AircraftPilot WHERE ID = @ap_id) AS AcftID,
	@PilotID,
	@ap_id,
	@isFlyingPattern,
	(select IsShared from Pilot where PilotID = @PilotID),
	NULL,
	@FlightControllerID,
	0,
	@SpeedThreshhold,
	@VersionCode,
	@Freq

DECLARE @id INT = SCOPE_IDENTITY() 

UPDATE Flight SET RouteID=ISNULL(@Routeid,@id) WHERE FlightID=@id

UPDATE FlightController SET
	FlightID = @id,
	r_ResponseData = @id
WHERE FlightControllerID = @FlightControllerID

SELECT FlightID FROM Flight WHERE FlightID = @id
	
--RETURN 0

END TRY
BEGIN CATCH
	DECLARE @ERRMSG VARCHAR(1024)= (SELECT ERROR_MESSAGE())
	INSERT INTO [dbo].[AppLog]
           ([Created]
           ,[Msg]
           ,[MsgType]
		   ,SPName
		   ,SPLine
		   )
	SELECT
           GETDATE()
           ,ERROR_MESSAGE()
           ,'ERROR'
		   ,ERROR_PROCEDURE()
		   ,ERROR_LINE()
RAISERROR(@ERRMSG,16,1)
--	--RETURN -1
END CATCH
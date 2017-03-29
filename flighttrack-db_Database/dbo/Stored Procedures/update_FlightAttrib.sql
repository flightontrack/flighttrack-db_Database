
CREATE PROCEDURE [dbo].[update_FlightAttrib]
	@FlightID	INT	= NULL,
	@FlightControllerID INT = NULL
AS

SET NOCOUNT ON

BEGIN TRY

UPDATE Flight
SET FlightControllerID=@FlightControllerID
WHERE FlightID=@FlightID

IF (SELECT IsRoad FROM FlightController WHERE FlightControllerID=@FlightControllerID) IS NOT NULL
BEGIN
	UPDATE Flight SET
	IsJunk = (SELECT IsRoad FROM FlightController WHERE FlightControllerID=@FlightControllerID)
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
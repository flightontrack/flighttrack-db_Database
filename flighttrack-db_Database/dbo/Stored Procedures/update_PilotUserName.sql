
CREATE PROCEDURE [dbo].[update_PilotUserName]
	@pilotcode			NVARCHAR(50),
	@deviceid			NVARCHAR(50),
	@pilotusername		NVARCHAR(250) = NULL

AS
SET NOCOUNT ON;
BEGIN TRY
UPDATE Pilot SET PilotUserName = @pilotusername WHERE SimNumber = @deviceid AND PilotCode=@pilotcode
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
	SELECT responseType=-1,response=0;
	THROW;
END CATCH

CREATE PROCEDURE [dbo].[create_Pilot]
	@pilotcode VARCHAR(50) = NULL,
	@deviceid VARCHAR(50) = NULL,
	@androidid VARCHAR(50)=NULL,
	--@userid VARCHAR(50) = NULL,
	@username VARCHAR(50) = NULL
AS

SET NOCOUNT ON
BEGIN TRY
MERGE Pilot AS t
USING (SELECT PilotCode = ISNULL(@pilotcode,0),
				SimNumber=ISNULL(@deviceid,0),
				AnID=ISNULL(@androidid,0),
				--UserId=@userid,
				UserName=left(@username,3)+'-....'+right(@username,3)) AS s ON t.PilotCode=s.PilotCode AND t.SimNumber=s.SimNumber
WHEN MATCHED THEN UPDATE SET PilotName=@username
WHEN NOT MATCHED THEN INSERT (PilotCode,SimNumber,AnID,PilotName) VALUES (s.PilotCode,s.simNumber,s.AnID,s.UserName) 
OUTPUT INSERTED.PilotID	AS PilotID;

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
	SELECT responseType=-1,response=0;
	THROW;
	RETURN -1
END CATCH
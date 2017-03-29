CREATE PROCEDURE [dbo].[get_PilotID]
	--@pilotcode			NVARCHAR(50),
	--@deviceid			NVARCHAR(50)
		@userid			NVARCHAR(50)
AS
SET NOCOUNT ON;
--SELECT PilotID FROM Pilot WHERE PilotCode = @pilotcode AND SimNumber = @deviceid
SELECT PilotID FROM Pilot WHERE PilotUserName =@userid
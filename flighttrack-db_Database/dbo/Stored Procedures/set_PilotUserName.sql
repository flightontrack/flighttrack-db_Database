
CREATE PROCEDURE [dbo].[set_PilotUserName]
	@deviceid			NVARCHAR(50),
	@pilotusername		NVARCHAR(250)

AS
SET NOCOUNT ON;
UPDATE Pilot SET PilotUserName = @pilotusername WHERE SimNumber = @deviceid
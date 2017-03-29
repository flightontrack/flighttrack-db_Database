
CREATE PROCEDURE [dbo].[update_Pilot]
	@userid			NVARCHAR(50),
	@username		NVARCHAR(50)
AS
SET NOCOUNT ON;
UPDATE Pilot SET PilotName = @username WHERE PilotUserName = @userid
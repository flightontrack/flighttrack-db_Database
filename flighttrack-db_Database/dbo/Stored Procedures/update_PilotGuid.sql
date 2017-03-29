

CREATE PROCEDURE [dbo].[update_PilotGuid]
	@pilotid		INT
AS
SET NOCOUNT ON;
UPDATE Pilot SET PilotGuid=(CONVERT([varchar](36),newid())) WHERE PilotId = @pilotid
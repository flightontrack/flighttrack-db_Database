
CREATE PROCEDURE [dbo].[get_PilotP]
		@phonenumber	VARCHAR(50),
		@deviceid		VARCHAR(50)
AS
SET NOCOUNT ON;

SELECT aP=SUBSTRING(LOWER(PilotGUid),10,2)+'$'+ SUBSTRING(LOWER(PilotGUid),20,4) 
FROM Pilot 
WHERE PilotCode =@phonenumber AND SimNumber=@deviceid
RETURN 0;
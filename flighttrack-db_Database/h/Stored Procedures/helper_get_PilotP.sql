


CREATE PROCEDURE [h].[helper_get_PilotP]
		@pilotid int = null,
		@phonenumber varchar(50) = null
AS
SET NOCOUNT ON;

if @pilotid is not null
begin
	SELECT aP=SUBSTRING(LOWER(PilotGUid),10,2)+'$'+ SUBSTRING(LOWER(PilotGUid),20,4) 
	FROM Pilot 
	WHERE PilotID = @pilotid
end

if @phonenumber is not null
begin
	SELECT aP=SUBSTRING(LOWER(PilotGUid),10,2)+'$'+ SUBSTRING(LOWER(PilotGUid),20,4) 
	FROM Pilot 
	WHERE PilotCode = @phonenumber
end
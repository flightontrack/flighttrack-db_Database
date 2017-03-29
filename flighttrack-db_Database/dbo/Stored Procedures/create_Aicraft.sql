
CREATE PROCEDURE [dbo].[create_Aicraft]
	@AcftNum VARCHAR(10),
	@AcftTagId VARCHAR(50) = NULL,
	@AcftName VARCHAR(100) = NULL,
	@Pilotid INT
AS
SET NOCOUNT ON

BEGIN TRY
DECLARE @ACFTID TABLE (acftid INT)
DECLARE @VARacftid INT = NULL,@VARacfpilottid INT = NULL

MERGE DimAircraftRemote AS t
USING (SELECT AcftNum = @AcftNum,AcftTagId=@AcftTagId) AS s ON t.AcftNum = s.AcftNum
WHEN MATCHED 
	THEN UPDATE SET @VARacftid = (SELECT AcftID FROM DimAircraftRemote WHERE AcftNum = @AcftNum)
WHEN NOT MATCHED 
	THEN INSERT (AcftNum,AcftTagId) VALUES (s.AcftNum,s.AcftTagId)
OUTPUT INSERTED.AcftID INTO @ACFTID;

MERGE AircraftPilot AS t
USING (SELECT AcftId = ISNULL(@VARacftid,(SELECT acftid FROM @ACFTID)), AcftNum = ISNULL(@AcftNum,0),AcftName=@AcftName, PilotID=@Pilotid) AS s ON t.AcftId = s.AcftId AND t.PilotID = s.Pilotid
WHEN MATCHED 
	THEN UPDATE SET @VARacfpilottid = (SELECT ID FROM [AircraftPilot] WHERE AcftId = s.AcftId AND PilotID = s.Pilotid)
WHEN NOT MATCHED 
	THEN INSERT (AcftId,AcftNumLocal,AcftName,PilotID) VALUES (s.AcftId,s.AcftNum,s.AcftName,s.PilotID);

DECLARE @VARacfpilottid_inserted INT = IDENT_CURRENT('dbo.AircraftPilot') 
	
RETURN ISNULL(@VARacfpilottid,@VARacfpilottid_inserted)

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
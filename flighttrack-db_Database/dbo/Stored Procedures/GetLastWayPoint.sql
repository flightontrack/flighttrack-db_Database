
CREATE PROCEDURE [dbo].[GetLastWayPoint]
	@flightid			NVARCHAR(50)
AS

SET NOCOUNT ON

SELECT MAX(onSessionPointNum) FROM GpsLocation WHERE FlightID=@flightid

RETURN 0
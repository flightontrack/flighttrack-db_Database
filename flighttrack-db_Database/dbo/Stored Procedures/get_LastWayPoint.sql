

CREATE PROCEDURE [dbo].[get_LastWayPoint]
	@flightid			NVARCHAR(50)
AS

SET NOCOUNT ON

SELECT responseType=0, response=MAX(onSessionPointNum) FROM GpsLocation WHERE FlightID=@flightid

RETURN 0
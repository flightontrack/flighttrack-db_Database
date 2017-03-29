CREATE  VIEW [dbo].[vListAirport]
 
AS
SELECT DISTINCT AirportID=a.ID,l.AirportCode 
FROM [dbo].GpsLocation l
JOIN [dbo].[AirportCoordinates] a ON l.AirportCode=a.Code
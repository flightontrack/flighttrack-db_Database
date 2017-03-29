




CREATE VIEW [dbo].[vListAircraft]
--WITH SCHEMABINDING
AS

SELECT a = 0,
	AcftID=ap.AcftNumLocal,
	AcftNumLocal,
	c=COUNT_BIG(*)
FROM [dbo].[Flight] f
JOIN [dbo].[AircraftPilot] ap ON f.AcftPilotID=ap.ID
GROUP BY  	ap.AcftNumLocal
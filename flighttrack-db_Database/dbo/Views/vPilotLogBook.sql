

CREATE  VIEW [dbo].[vPilotLogBook]
--WITH SCHEMABINDING
AS

SELECT 
	RouteID
	,d.FlightDateOnly
	,Comments= STUFF((SELECT '-' + Comments FROM [dbo].[Flight] WHERE RouteID=f.RouteID ORDER BY FlightID FOR XML PATH('')) , 1, 1, '' )
	,AcftMMS=COALESCE(r.AcftMMS,AcftNumLocal)
	,Acft = COALESCE(r.[N-NUMBER],ap.AcftNumLocal)
	--,AcftNum = COALESCE(r.[N-NUMBER],ap.AcftNumLocal)
	,AcftRegNum = COALESCE(r.[N-NUMBER],'Not Found')
	,f.PilotID
	,NoLandings=COUNT(*)
	,FlightDurationMin=SUM(FlightDurationMin)
	,RouteName=STUFF((SELECT '-' + IIF(FlightID != MIN(FlightID) OVER(PARTITION BY RouteID), SUBSTRING(FlightName,CHARINDEX('-',FlightName,0)+1,100),FlightName) FROM [dbo].[Flight] WHERE RouteID=f.RouteID ORDER BY FlightID FOR XML PATH('')) , 1, 1, '' )
	,IsJunk=ISNULL(IsJunk,0)
	,IsShared
FROM [dbo].[Flight] f
LEFT JOIN [dbo].DimAircraftRemote a ON f.AcftID=a.AcftID
LEFT JOIN [dbo].AircraftPilot ap ON f.AcftPilotID=ap.ID
LEFT JOIN [dbo].DimAcftRegistry r ON ap.AcftNumLocal=r.[N-NUMBER]
OUTER APPLY (SELECT FlightDateOnly=CONVERT(VARCHAR(10),MIN([FlightDate]),101) FROM [dbo].[Flight] WHERE RouteID = f.RouteID ) AS d
WHERE ISNULL(IsJunk,0) =0
GROUP BY RouteID,ap.AcftNumLocal,f.PilotID,IsShared,IsJunk,r.AcftMMS,r.[N-NUMBER],d.FlightDateOnly
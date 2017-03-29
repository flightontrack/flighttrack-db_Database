




CREATE  VIEW [dbo].[vAircraftPilot]
--WITH SCHEMABINDING
AS
SELECT 
	ap.ID
	,a.AcftID
	--,a.[AcftCode]
	,ap.AcftName
	,a.AcftTagID
	,AcftMake = r.MFR
	,AcftModel = r.MODEL
	,AcftRegNum=COALESCE(r.[N-NUMBER],'Not Found')
	,r.AcftMMS
	,SerNum = r.[SERIAL NUMBER]
	,ap.AcftNumLocal
	,a.Created
	,FlightTime
	,ap.PilotID
	,p.PilotCode
  FROM [dbo].[DimAircraftRemote] a
  JOIN [dbo].[AircraftPilot] ap ON a.[AcftID] = ap.[AcftID]
  JOIN [dbo].[Pilot] p ON ap.PilotID =p.PilotID
  LEFT JOIN [dbo].DimAcftRegistry r ON ap.AcftNumLocal=r.[N-NUMBER]
  OUTER APPLY (SELECT FlightTime = CAST(SUM([FlightDurationMin])/60.0 AS NUMERIC(9,2)) FROM [dbo].Flight f WHERE f.AcftPilotID=ap.ID) t
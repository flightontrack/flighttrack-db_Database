

CREATE  VIEW [dbo].[vFlightAcftPilot]
--WITH SCHEMABINDING
AS

SELECT f.FlightID
	,RouteID
	,FlightName
	,[FlightDate]
	,[FlightDateOnly] = convert(VARCHAR(10),[FlightDate],101)
	,[FlightTimeStart]
	,[FlightDurationMin]
	,f.[IsShared]
	,[Points]
	,[IsChecked]
	,IsJunk = isnull(IsJunk,0)
	,Comments
	,AcftRegNum= coalesce(r.[N-NUMBER],'Not Found')
	,r.AcftMMS
	,ap.AcftNumLocal
	,AcftNum = coalesce(r.[N-NUMBER],ap.AcftNumLocal)
	,Acft = coalesce(r.AcftMMS,ap.AcftName,ap.AcftNumLocal)
	,f.AcftID
	,f.PilotID
	,f.Updated
	,p.PilotCode
	,Pilot=coalesce(p.PilotName,left(p.PilotCode,3)+'-....'+right(p.PilotCode,3))
	,ap.AcftName
	,isPositionCurrent=iif(datediff(ss,f.Updated,getdate())<=6,1,0)
	,isInFlight=iif(FlightStateId=3 AND datediff(ss,f.Updated,getdate())<=60,1,0)
	,UpdateDelay = datediff(ss,f.Updated,getdate())
	--,ot.AltitudeFt
	,l.AltitudeFt
	--,isPositionCurrent=iif(FlightID IN (5320),1,0)
	--,isInFlight=1
  FROM [dbo].[Flight] f
  LEFT JOIN [dbo].DimAircraftRemote a ON f.AcftID=a.AcftID
  LEFT JOIN [dbo].Pilot p ON f.PilotID=p.PilotID
  LEFT JOIN [dbo].AircraftPilot ap ON f.AcftPilotID=ap.ID
  LEFT JOIN [dbo].DimAcftRegistry r ON ap.AcftNumLocal=r.[N-NUMBER]
	--OUTER APPLY (SELECT [AltitudeFt] FROM 
	--(SELECT AltitudeFt,Onsessionpointnum,M= MAX(Onsessionpointnum) OVER(PARTITION BY FlightID) FROM [dbo].GpsLocation WHERE FlightID =f.FlightID) t
	--WHERE onSessionPointNum=M) ot
  LEFT JOIN [dbo].GpsLocation l ON f.Last_GPSLocationID=l.GPSLocationID
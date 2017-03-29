

CREATE  view [dbo].[vVisualPilotLogBook]
AS

with rte as(
	select 
		RouteID
		,FlightDateOnly= cast([FlightDate] as date)
		,AcftMMS=COALESCE(r.AcftMMS,AcftNumLocal)
		,Acft = COALESCE(r.[N-NUMBER],ap.AcftNumLocal)
		,AcftRegNum = COALESCE(r.[N-NUMBER],'Not Found')
		,f.PilotID
		,NoLandings=COUNT(*)
		,RouteDurationMin=SUM(FlightDurationMin)
	from [dbo].[Flight] f
	left join [dbo].DimAircraftRemote a on f.AcftID=a.AcftID
	left join [dbo].AircraftPilot ap on f.AcftPilotID=ap.ID
	left join [dbo].DimAcftRegistry r on ap.AcftNumLocal=r.[N-NUMBER]
	where isnull(f.IsJunk,0) =0
	group by RouteID,ap.AcftNumLocal,f.PilotID,cast([FlightDate] as date),r.AcftMMS,r.[N-NUMBER]
),
fl as (
	select rte.* , f.FlightID,f.FlightDurationMin, f.Comments,f.Points,f.Flightname
	from rte
	join Flight f on rte.RouteID = f.RouteID and ISNULL(f.IsJunk,0) =0
)
,gmami as(
	select order_id = '1',g.flightid, GPSLocationID = min([GPSLocationID])
	from [dbo].[GpsLocation] g
	group by g.flightid
	union
	select order_id = '2',g.flightid, GPSLocationID = max([GPSLocationID])
	from [dbo].[GpsLocation] g
	group by g.flightid
)
,prefinal as (
	select fl.*, gmami.GPSLocationID ,gmami.order_id, AirportCode=ac.Code ,g.longitude,g.latitude
	from fl
	join gmami on fl.flightid = gmami.flightid
	join GpsLocation g on gmami.GPSLocationID = g.GPSLocationID
	left join AirportCoordinates ac on ac.GeoLocbuffer.STIntersects(g.GeoLocation)=1  AND ABS(g.AltitudeFt-ac.AltDecimal) <200
)
,route_name as
(
	select distinct RouteID,rn.RouteName
	from prefinal v
	outer apply (select RouteName=cast(stuff((select distinct  '-' +AirportCode from  prefinal where RouteID  = v.RouteID  for xml path('')) , 1, 1, '' ) as varchar(10))) as rn
)
select 
	prefinal.RouteID
	,FlightDate=FlightDateOnly
	,AcftMMS
	,Acft
	,AcftRegNum
	,PilotID
	,RouteDurationMin
	,route_name.RouteName
	,NoLandings
	,FlightID
	,FlightName
	,FlightDurationMin = iif(order_id=2,FlightDurationMin,0)
	,Comments
	,Points
	,GPSLocationID
	,order_id
	,AirportCode=isnull(AirportCode,'Unknown Dest')
	,longitude
	,latitude
from  prefinal
left join route_name on prefinal.RouteID = route_name .RouteID


CREATE FUNCTION [dbo].[fVisualPilotLogDestinations]
(	
	@pilotId int
)
RETURNS TABLE 
AS
RETURN 
(
with 
ba as (
	select BaseAirport, Long, Lat 
	from Pilot p
	left join AirportCoordinates ap on p.BaseAirport = ap.Code
	where PilotID = @pilotId
)
,a as (
select 
	PilotID,
	FlightID,
	flightN=FlightID+(row_number() over(partition by FlightID order by FlightID))/10.0,
	longitude,
	latitude,
	dest_order_id =2,
	AirportCode, 
	flightweight = 1
from dbo.fVisualPilotLogBook(@pilotId)
),
b as (
select
	PilotID,
	FlightID,
	flightN,
	longitude,
	latitude,
	dest_order_id,
	AirportCode, 
	flightweight,
	ba.BaseAirport
from a
left join ba on 1=1
where a.AirportCode != ba.BaseAirport
)
select 
	PilotID,
	FlightID,
	flightN,
	longitude,
	latitude,
	dest_order_id,
	AirportCode, 
	flightweight
from b
union all
select 
	PilotID,
	FlightID,
	flightN,
	---71.7928611,
	--42.4259167,
	Long,
	Lat,
	dest_order_id =1, 
	AirportCode = upper(b.BaseAirport), 
	flightweight = 0 
from b
left join ba on b.BaseAirport=ba.BaseAirport
)

CREATE view [dbo].[vVisualPilotLogDestinations]
as

select 
	PilotID,
	FlightID,
	flightN=FlightID+(row_number() over(partition by FlightID order by FlightID))/10.0,
	longitude,
	latitude,
	dest_order_id =2,
	AirportCode, 
	flightweight = 1
from vVisualPilotLogBook
where ISNULL(AirportCode,'0') != '3B3'
union all
select 
	PilotID,
	FlightID,
	flightN=FlightID+(row_number() over(partition by FlightID order by FlightID))/10.0,
	-71.7928611,
	42.4259167,
	dest_order_id =1, 
	'3B3', 
	flightweight = 0 
from vVisualPilotLogBook
where isnull(AirportCode,'0') != '3B3'



CREATE PROCEDURE [h].[helper_force_ref_integrity]

AS
SET NOCOUNT ON;

delete From flightcontroller 
where flightid not in (select flightid from flight )
and flightid >0

if not exists(select 0 from flight where flightid = 0)
begin
	set identity_insert flight on
	insert into flight (flightid, FlightName)
	select 0, 'Default Flight'
	set identity_insert flight off
end

delete from gpslocation 
where flightid not in (select flightid from flight )

update pilot set IsShared = 1 where IsShared is null
CREATE PROC [dbo].[get_isArea] 
(
	@GpsLocationID int,
	@AreaID int
)
AS
	--DECLARE @Result int

	SELECT sArea= ISNULL(t2.GeoLocbuffer.STIntersects(t1.GeoLocation),0)
	FROM GpsLocation t1
	LEFT JOIN DimArea t2 
	ON t2.GeoLocbuffer.STIntersects(t1.GeoLocation)=1
	WHERE t1.GpsLocationID=@GpsLocationID AND t2.AreaID=@AreaID

	--RETURN @Result
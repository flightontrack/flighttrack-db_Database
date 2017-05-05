CREATE PROC [dbo].[get_isArea] 
(
	@GpsLocationID int,
	@AreaID int,
	@Radius char(2)=null
)
AS
	--DECLARE @Result int
	IF @Radius = '3'
		SELECT sArea= ISNULL(t2.GeoLocbuffer.STIntersects(t1.GeoLocation),0)
		FROM GpsLocation t1
		LEFT JOIN DimArea t2 
		ON t2.GeoLocbuffer_3.STIntersects(t1.GeoLocation)=1
		WHERE t1.GpsLocationID=@GpsLocationID AND t2.AreaID=@AreaID
	
	IF @Radius = '5'
		SELECT sArea= ISNULL(t2.GeoLocbuffer.STIntersects(t1.GeoLocation),0)
		FROM GpsLocation t1
		LEFT JOIN DimArea t2 
		ON t2.GeoLocbuffer_5.STIntersects(t1.GeoLocation)=1
		WHERE t1.GpsLocationID=@GpsLocationID AND t2.AreaID=@AreaID

	IF @Radius = '10'
		SELECT sArea= ISNULL(t2.GeoLocbuffer.STIntersects(t1.GeoLocation),0)
		FROM GpsLocation t1
		LEFT JOIN DimArea t2 
		ON t2.GeoLocbuffer_10.STIntersects(t1.GeoLocation)=1
		WHERE t1.GpsLocationID=@GpsLocationID AND t2.AreaID=@AreaID

	IF @Radius = '15'
		SELECT sArea= ISNULL(t2.GeoLocbuffer.STIntersects(t1.GeoLocation),0)
		FROM GpsLocation t1
		LEFT JOIN DimArea t2 
		ON t2.GeoLocbuffer_15.STIntersects(t1.GeoLocation)=1
		WHERE t1.GpsLocationID=@GpsLocationID AND t2.AreaID=@AreaID

	ELSE
		SELECT sArea= ISNULL(t2.GeoLocbuffer.STIntersects(t1.GeoLocation),0)
		FROM GpsLocation t1
		LEFT JOIN DimArea t2 
		ON t2.GeoLocbuffer.STIntersects(t1.GeoLocation)=1
		WHERE t1.GpsLocationID=@GpsLocationID AND t2.AreaID=@AreaID
	--RETURN @Result
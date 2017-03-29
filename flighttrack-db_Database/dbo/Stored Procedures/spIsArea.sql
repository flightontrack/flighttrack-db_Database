CREATE PROC [dbo].[spIsArea] 
(
	@GpsLocationID int,
	@AreaID int
)
AS
BEGIN
	DECLARE @Result int

	SELECT @Result= ISNULL(t2.GeoLocbuffer.STIntersects(t1.GeoLocation),0)
	FROM GpsLocation t1
	JOIN DimArea t2 
	ON t2.GeoLocbuffer.STIntersects(t1.GeoLocation)=1
	WHERE t1.GpsLocationID=@GpsLocationID AND t2.AreaID=@AreaID

	RETURN @Result
END
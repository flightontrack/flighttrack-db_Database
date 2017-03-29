
CREATE PROCEDURE [dbo].[set_FlightController]
	@requestID	NVARCHAR(10),
	@flightid		NVARCHAR(50) = NULL,
	--@ispattern		NVARCHAR(50) = NULL,
	@speed			NVARCHAR(50) = NULL,
	@isspeedlow	BIT =NULL,
	@isroad		BIT = NULL
AS

DECLARE @newFlightControllerID INT = NULL,
		@flightControllerID INT = NULL,
		@flightStateID INT = NULL,	
		@cur_r_ResponseType INT = NULL,	
		@cur_r_ResponseData VARCHAR(50) = NULL,
		@speedMin INT = NULL

SET NOCOUNT ON;
/* 
	get latest controller id for the flight from Flight table
	get latest response data and type from FlightController table
*/
SELECT TOP 1 @flightControllerID = FlightControllerID,@flightStateID = FlightStateID,@speedMin=SpeedThreshhold FROM Flight WHERE FlightID = @flightid
--SELECT TOP 1 @cur_r_ResponseType = r_ResponseType, @cur_r_ResponseData=r_ResponseData FROM FlightController WHERE @flightControllerID = FlightControllerID

BEGIN TRY
-- BEGIN TRAN
/*  
	check if any flight parameters changed.
	if changed insert a new record in flightController table.
	Get IsMaxAllowedPointsReached from AppProperties table.
	Get response data and type populated from previous record. ???????
*/

;WITH input AS(
	SELECT
	RequestID=@requestID,
	FlightID=@FlightID,
	FlightStateID =	@flightStateID,
	IsAboveSpeedBottomTreshhold=CASE WHEN @speed IS NULL THEN NULL ELSE  COALESCE(~@isspeedlow,IIF(CAST(@speed AS INT)>@speedMin,1,0),1) END,
	IsPattern=(SELECT IsPattern FROM Flight WHERE FlightID=@FlightID),
	IsMaxAllowedPointsReached=	CASE	WHEN (SELECT Points FROM Flight WHERE FlightID=@FlightID) >CAST((SELECT PropertyValue FROM AppProperties WHERE PropertyKey='maxAllowedFlightPointsCount') AS INT) THEN 1 
										WHEN (SELECT Points FROM Flight WHERE FlightID=@FlightID) <=CAST((SELECT PropertyValue FROM AppProperties WHERE PropertyKey='maxAllowedFlightPointsCount') AS INT) THEN 0 END,
	IsRoad = @isroad
)

MERGE FlightController targ
USING input AS src
ON targ.FlightControllerID = @flightControllerID
AND targ.RequestID=src.RequestID 
AND ISNULL(targ.FlightID,1)=ISNULL(src.FlightID,1)  
AND ISNULL(targ.FlightStateID,1)=ISNULL(src.FlightStateID,1) 
AND ISNULL(targ.IsAboveSpeedBottomTreshhold,1)=ISNULL(src.IsAboveSpeedBottomTreshhold,1) 
--AND ISNULL(targ.IsPattern,1)=ISNULL(src.IsPattern,1) 
AND ISNULL(targ.IsMaxAllowedPointsReached,1)=ISNULL(src.IsMaxAllowedPointsReached,1)
AND 
	(targ.IsRoad IS NULL AND src.IsRoad IS NULL)  

WHEN NOT MATCHED THEN
INSERT  (
	RequestID,
	FlightID,
	FlightStateID,
	IsAboveSpeedBottomTreshhold,
	IsPattern,
	IsMaxAllowedPointsReached,
	IsRoad,
	r_ResponseType,
	r_ResponseData)
VALUES (
	src.RequestID,
	src.FlightID,
	src.FlightStateID,
	src.IsAboveSpeedBottomTreshhold,
	src.IsPattern,
	src.IsMaxAllowedPointsReached,
	src.IsRoad,
	null, --@cur_r_ResponseType,
	null --@cur_r_ResponseData
);


SET @newFlightControllerID = SCOPE_IDENTITY() 
IF @newFlightControllerID IS NOT NULL
BEGIN
/*  
	Get action now from FlightAction for newly inserted record. 
	Update response type data and command.
*/

	--FROM FlightController t2
	--JOIN FlightAction t1 ON t1.ChecksumID =	t2.ChecksumID_Request
	--WHERE t2.FlightControllerID = @newFlightControllerID

	UPDATE t2 SET
		r_ChecksumID_Response = t1.ChecksumID
		,r_ResponseType = ISNULL(t1.r_ResponseType,t2.r_ResponseType)
		,r_ResponseData = ISNULL(t1.r_ResponseData,t2.r_ResponseData)
		,r_ResponseCommand = ISNULL(t1.r_ResponseCommand,t2.r_ResponseCommand)
		,a_IsSetLocation = t1.a_IsSetLocation
		,a_IsCreateFlight = t1.a_IsCreateFlight
		,a_IsUpdFlightStatus = t1.a_IsUpdFlightStatus
		,a_IsUpdFlightStatus_FlightState= t1.a_IsUpdFlightStatus_FlightState
		,a_IsUpdFlightStatus_FlightStateID = t1.a_IsUpdFlightStatus_FlightStateID
		,a_IsUpdFlightAttrib = t1.a_IsUpdFlightAttrib
		--,a_IsUpdFlightAttrib_LastGPSLocationID = t1.a_IsUpdFlightAttrib_LastGPSLocationID
		--,a_IsUpdFlightAttrib_Points = t1.a_IsUpdFlightAttrib_Points
		,a_FlightActionID = t1.FlightActionID
	OUTPUT inserted.a_IsCreateFlight,inserted.a_IsUpdFlightStatus,inserted.a_IsUpdFlightAttrib,inserted.a_IsSetLocation,inserted.FlightControllerID,inserted.a_IsUpdFlightStatus_FlightStateID AS FlightStateID,inserted.r_ChecksumID_Response AS ChecksumID_Response
	FROM FlightController t2
	JOIN FlightAction t1 ON 
		ISNULL(t1.RequestID,ISNULL(t2.RequestID,0)) = ISNULL(t2.RequestID,0) AND
		ISNULL(t1.FlightStateID,ISNULL(t2.FlightStateID,0)) = ISNULL(t2.FlightStateID,0) AND
		ISNULL(t1.IsPattern,ISNULL(t2.IsPattern,0)) = ISNULL(t2.IsPattern,0) AND
		ISNULL(t1.IsAboveSpeedBottomTreshhold,ISNULL(t2.IsAboveSpeedBottomTreshhold,0)) = ISNULL(t2.IsAboveSpeedBottomTreshhold,0) AND
		ISNULL(t1.IsMaxAllowedPointsReached,ISNULL(t2.IsMaxAllowedPointsReached,0)) = ISNULL(t2.IsMaxAllowedPointsReached,0) AND
		ISNULL(t1.IsRoad,ISNULL(t2.IsRoad,0)) = ISNULL(t2.IsRoad,0)
	WHERE t2.FlightControllerID = @newFlightControllerID
END
ELSE 
BEGIN

/*
	output the action for application
*/
	SELECT 
	a_IsCreateFlight=CAST(0 AS BIT),
	a_IsUpdFlightStatus=CAST(0 AS BIT),
	a_IsUpdFlightAttrib=CAST(0 AS BIT),
	a_IsSetLocation,
	FlightControllerID,
	FlightStateID,
	ChecksumID_Response=1
	FROM FlightController 
	WHERE FlightControllerID = @flightControllerID
END
-- COMMIT TRAN
RETURN 0
END TRY

BEGIN CATCH
	--THROW;
	IF @@TRANCOUNT>0 ROLLBACK TRAN
	DECLARE @ERRMSG VARCHAR(1024)= (SELECT ERROR_MESSAGE())
	INSERT INTO [dbo].[AppLog]
           ([Created]
           ,[Msg]
           ,[MsgType])
     VALUES (
           GETDATE()
           ,@ERRMSG
           ,'ERROR')
	RAISERROR(@ERRMSG,16,1)
	RETURN -1
END CATCH
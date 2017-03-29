


CREATE PROCEDURE [dbo].[get_Response]
	@FlightControllerID INT
AS

SET NOCOUNT ON
SELECT 
    responseType=r_ResponseType,
    responseData=r_ResponseData,
	responseCommand=r_ResponseCommand,
	responseFlightId=FlightId
FROM FlightController
WHERE FlightControllerID = @FlightControllerID
	
RETURN 0
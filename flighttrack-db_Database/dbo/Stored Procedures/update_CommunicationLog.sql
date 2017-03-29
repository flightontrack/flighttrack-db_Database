

CREATE PROC [dbo].[update_CommunicationLog]
		@commlogid INT = NULL,
		@response NVARCHAR(250) = NULL
AS
UPDATE [dbo].[CommunicationLog]
SET return_response = @response,
	Updated = GETDATE()
WHERE CommunicationlogID = @commlogid
CREATE PROC [dbo].[set_AppStatus]
		@request int,
		@phoneNumber varchar(20) = '-1',
		@deviceId varchar(20) = '-1',
		@isClockon bit,
		@isRestart bit = null,
		@flightId int,
		@battery varchar(10)

AS

if 
(select count(*) from [dbo].[AppStatus]) = 0
	or
(checksum(@request,@phoneNumber,@isClockon,@IsRestart,@flightId) != (select top 1 ChecksumID from [dbo].[AppStatus] where [Phone]= @phoneNumber order by AppStatusID desc))

	INSERT INTO [dbo].[AppStatus]
		(
		[RequestID]
		,[Phone]
		,[Device]
		,[FlightID]
		,[IsClockOn]
		,[isRestart]
		,Battery
	)
	OUTPUT INSERTED.AppStatusID
		VALUES
		(@request
		,@phoneNumber
		,@deviceId
		,@flightId
		,@isClockon
		,@isRestart
		,@battery
		)

else 
	update [dbo].[AppStatus] set Updated = getdate(),Cnt +=1  where AppStatusID= (select max(AppStatusID) from AppStatus where [Phone]=@phoneNumber)
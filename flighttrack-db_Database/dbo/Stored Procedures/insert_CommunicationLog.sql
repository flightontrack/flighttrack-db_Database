CREATE PROC [dbo].[insert_CommunicationLog]
           @rcode NVARCHAR(250) = NULL
           ,@flightid NVARCHAR(250) = NULL
           ,@speed NVARCHAR(250) = NULL
           ,@speedlowflag NVARCHAR(250) = NULL
           ,@phonenumber NVARCHAR(250) = NULL
           ,@deviceid NVARCHAR(250) = NULL
           ,@aid NVARCHAR(250) = NULL
           ,@AcftMake NVARCHAR(250) = NULL
           ,@AcftModel NVARCHAR(250) = NULL
           ,@AcftSeries NVARCHAR(250) = NULL
           ,@AcftRegNum NVARCHAR(250) = NULL
           ,@AcftTagId NVARCHAR(250) = NULL
		   ,@AcftName NVARCHAR(100) = NULL
           ,@isFlyingPattern NVARCHAR(250) = NULL
           ,@speed_thresh NVARCHAR(250) = NULL
           ,@latitude NVARCHAR(250) = NULL
           ,@longitude NVARCHAR(250) = NULL
           ,@accuracy NVARCHAR(250) = NULL
           ,@extrainfo NVARCHAR(250) = NULL
           ,@wpntnum NVARCHAR(250) = NULL
		   ,@userid NVARCHAR(250) = NULL
		   ,@username NVARCHAR(250) = NULL
		   ,@freq NVARCHAR(250) = NULL
		   ,@routeId NVARCHAR(250) = NULL
		   ,@appversioncode NVARCHAR(250) = NULL
		   ,@elevcheck NVARCHAR(250) = NUL
AS
INSERT INTO [dbo].[CommunicationLog]
		([rcode]
		,[flightid]
		,[speed]
		,[speedlowflag]
		,[phonenumber]
		,[deviceid]
		,[aid]
		,[AcftMake]
		,[AcftModel]
		,[AcftSeries]
		,[AcftRegNum]
		,[AcftTagId]
		,AcftName
		,[isFlyingPattern]
		,[speed_thresh]
		,[latitude]
		,[longitude]
		,[accuracy]
		,[extrainfo]
		,[wpntnum]
		,userid
		,username
		,freq
		,routeId
		,appversioncode
		,elevcheck

		)
	 OUTPUT INSERTED.CommunicationlogID
     VALUES
		(@rcode
		,@flightid
		,@speed
		,@speedlowflag
		,@phonenumber
		,@deviceid
		,@aid
		,@AcftMake
		,@AcftModel
		,@AcftSeries
		,@AcftRegNum
		,@AcftTagId
		,@AcftName
		,@isFlyingPattern
		,@speed_thresh
		,@latitude
		,@longitude
		,@accuracy
		,@extrainfo
		,@wpntnum
		,@userid
		,@username
		,@freq
		,@routeId
		,@appversioncode
		,@elevcheck
		)
CREATE TABLE [dbo].[AppStatus] (
    [AppStatusID] INT          IDENTITY (1, 1) NOT NULL,
    [ChecksumID]  AS           (checksum([RequestID],[Phone],[IsClockOn],[IsRestart],[FlightID])) PERSISTED,
    [Request]     VARCHAR (50) NULL,
    [RequestID]   INT          NULL,
    [Phone]       VARCHAR (20) NULL,
    [Device]      VARCHAR (50) NULL,
    [FlightID]    INT          NULL,
    [IsClockOn]   BIT          NULL,
    [IsRestart]   BIT          NULL,
    [Battery]     VARCHAR (10) NULL,
    [Cnt]         INT          CONSTRAINT [DF_AppStatus_Counter] DEFAULT ((0)) NULL,
    [Updated]     DATETIME     CONSTRAINT [DF_AppStatus_Updated] DEFAULT (getdate()) NOT NULL,
    [Created]     DATETIME     CONSTRAINT [DF_AppStatus_Created] DEFAULT (getdate()) NULL
);


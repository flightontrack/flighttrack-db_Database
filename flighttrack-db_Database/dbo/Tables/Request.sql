CREATE TABLE [dbo].[Request] (
    [RequestID] INT          NOT NULL,
    [Request]   VARCHAR (50) NULL,
    CONSTRAINT [PK_Request] PRIMARY KEY CLUSTERED ([RequestID] ASC)
);


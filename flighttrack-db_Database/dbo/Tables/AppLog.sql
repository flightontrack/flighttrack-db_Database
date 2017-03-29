CREATE TABLE [dbo].[AppLog] (
    [ID]      INT             IDENTITY (1, 1) NOT NULL,
    [Created] DATETIME        NULL,
    [Msg]     NVARCHAR (1024) NULL,
    [MsgType] NCHAR (10)      NULL,
    [SPName]  VARCHAR (256)   NULL,
    [SPLine]  VARCHAR (10)    NULL,
    CONSTRAINT [PK_AppLog] PRIMARY KEY CLUSTERED ([ID] ASC)
);


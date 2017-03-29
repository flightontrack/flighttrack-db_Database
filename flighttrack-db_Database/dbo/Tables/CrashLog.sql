CREATE TABLE [dbo].[CrashLog] (
    [CrashId]   INT           IDENTITY (1, 1) NOT NULL,
    [CrashText] VARCHAR (MAX) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [PK_CrashLog]
    ON [dbo].[CrashLog]([CrashId] ASC);


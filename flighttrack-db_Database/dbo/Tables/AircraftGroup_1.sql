CREATE TABLE [dbo].[AircraftGroup] (
    [Id]      INT      IDENTITY (1, 1) NOT NULL,
    [AcftID]  INT      NULL,
    [GroupID] INT      NULL,
    [Created] DATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


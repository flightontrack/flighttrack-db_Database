CREATE TABLE [dbo].[AircraftGroup]
(
	[Id] INT IDENTITY NOT NULL PRIMARY KEY, 
    [AcftID] INT NULL, 
    [GroupID] INT NULL, 
    [Created] DATETIME NULL DEFAULT getdate()

)

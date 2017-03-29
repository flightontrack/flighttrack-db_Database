CREATE TABLE [dbo].[DimAircraftRemote] (
    [AcftID]    INT           IDENTITY (1, 1) NOT NULL,
    [AcftNum]   NVARCHAR (50) NULL,
    [AcftTagId] VARCHAR (50)  NULL,
    [Created]   DATETIME      CONSTRAINT [DF_DimAircraftRemote_Created] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_DimAircraftRemote] PRIMARY KEY CLUSTERED ([AcftID] ASC)
);


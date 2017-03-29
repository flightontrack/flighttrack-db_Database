CREATE TABLE [dbo].[DimArea] (
    [AreaID]       INT             IDENTITY (1, 1) NOT NULL,
    [AreaName]     VARCHAR (250)   NULL,
    [CenterLat]    DECIMAL (13, 8) NULL,
    [CenterLong]   DECIMAL (13, 8) NULL,
    [CenterPoint]  AS              ([geography]::Point([CenterLat],[CenterLong],(4326))) PERSISTED,
    [Radius]       INT             NULL,
    [Area]         AS              ([geography]::Point([CenterLat],[CenterLong],(4326)).STBuffer([Radius])) PERSISTED,
    [GeoLocBuffer] AS              ([geography]::Point([CenterLat],[CenterLong],(4326)).STBuffer([Radius])) PERSISTED
);


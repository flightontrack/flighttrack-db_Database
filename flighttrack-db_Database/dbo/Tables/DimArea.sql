CREATE TABLE [dbo].[DimArea] (
    [AreaID]          INT             IDENTITY (1, 1) NOT NULL,
    [AreaName]        VARCHAR (250)   NULL,
    [CenterLat]       DECIMAL (13, 8) NULL,
    [CenterLong]      DECIMAL (13, 8) NULL,
    [CenterPoint]     AS              ([geography]::Point([CenterLat],[CenterLong],(4326))) PERSISTED,
    [Radius]          INT             NULL,
    [Area]            AS              ([geography]::Point([CenterLat],[CenterLong],(4326)).STBuffer([Radius])) PERSISTED,
    [GeoLocBuffer]    AS              ([geography]::Point([CenterLat],[CenterLong],(4326)).STBuffer([Radius])) PERSISTED,
    [Radius_3]        INT             NULL,
    [Radius_5]        INT             NULL,
    [Radius_10]       INT             NULL,
    [Radius_15]       INT             NULL,
    [GeoLocBuffer_3]  AS              ([geography]::Point([CenterLat],[CenterLong],(4326)).STBuffer([Radius_3])) PERSISTED,
    [GeoLocBuffer_5]  AS              ([geography]::Point([CenterLat],[CenterLong],(4326)).STBuffer([Radius_5])) PERSISTED,
    [GeoLocBuffer_10] AS              ([geography]::Point([CenterLat],[CenterLong],(4326)).STBuffer([Radius_10])) PERSISTED,
    [GeoLocBuffer_15] AS              ([geography]::Point([CenterLat],[CenterLong],(4326)).STBuffer([Radius_15])) PERSISTED
);




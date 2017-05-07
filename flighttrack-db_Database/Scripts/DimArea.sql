ALTER TABLE [dbo].[DimArea]
    ADD [Radius_3]        INT  DEFAULT ((3000)),
        [Radius_5]        INT  DEFAULT ((5000)),
        [Radius_10]       INT  DEFAULT ((10000)),
        [Radius_15]       INT  DEFAULT ((15000))
GO
truncate table [dbo].[DimArea]
SET IDENTITY_INSERT [dbo].[DimArea] ON
INSERT INTO [dbo].[DimArea] ([AreaID], [AreaName], [CenterLat], [CenterLong], [Radius], [Radius_3], [Radius_5], [Radius_10], [Radius_15]) VALUES (1, N'3B3', CAST(42.42591687 AS Decimal(13, 8)), CAST(-71.79286122 AS Decimal(13, 8)),  10000, 3000, 5000, 10000, 15000)
INSERT INTO [dbo].[DimArea] ([AreaID], [AreaName], [CenterLat], [CenterLong], [Radius], [Radius_3], [Radius_5], [Radius_10], [Radius_15]) VALUES (2, N'Woodvale', CAST(42.50998400 AS Decimal(13, 8)), CAST(-71.41953600 AS Decimal(13, 8)), 10000, 3000, 5000, 10000, 15000)
INSERT INTO [dbo].[DimArea] ([AreaID], [AreaName], [CenterLat], [CenterLong], [Radius], [Radius_3], [Radius_5], [Radius_10], [Radius_15]) VALUES (4, N'Volpe', CAST(42.36394700 AS Decimal(13, 8)), CAST(-71.08573400 AS Decimal(13, 8)),  10000, 3000, 5000, 10000, 15000)
SET IDENTITY_INSERT [dbo].[DimArea] OFF

ALTER TABLE [dbo].[DimArea]
    ADD 
	[GeoLocBuffer_3]  AS ([geography]::Point([CenterLat],[CenterLong],(4326)).STBuffer([Radius_3])) PERSISTED,
	[GeoLocBuffer_5]  AS ([geography]::Point([CenterLat],[CenterLong],(4326)).STBuffer([Radius_5])) PERSISTED,
	[GeoLocBuffer_10]  AS ([geography]::Point([CenterLat],[CenterLong],(4326)).STBuffer([Radius_10])) PERSISTED,
	[GeoLocBuffer_15]  AS ([geography]::Point([CenterLat],[CenterLong],(4326)).STBuffer([Radius_15])) PERSISTED
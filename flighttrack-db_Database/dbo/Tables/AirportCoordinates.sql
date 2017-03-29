CREATE TABLE [dbo].[AirportCoordinates] (
    [ID]           INT               IDENTITY (1, 1) NOT NULL,
    [Code]         VARCHAR (50)      NULL,
    [Lat]          VARCHAR (50)      NULL,
    [Long]         VARCHAR (50)      NULL,
    [Alt]          VARCHAR (50)      NULL,
    [GeoLocation]  [sys].[geography] NULL,
    [LatDecimal]   DECIMAL (13, 8)   NULL,
    [LongDecimal]  DECIMAL (13, 8)   NULL,
    [AltDecimal]   INT               NULL,
    [GeoLocBuffer] [sys].[geography] NULL,
    CONSTRAINT [PK_AirportCoordinates] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_AirportCoordinates_LatLong]
    ON [dbo].[AirportCoordinates]([LatDecimal] ASC, [LongDecimal] ASC);


GO
CREATE SPATIAL INDEX [six1]
    ON [dbo].[AirportCoordinates] ([GeoLocBuffer])
    USING GEOGRAPHY_GRID
    WITH  (
            GRIDS = (LEVEL_1 = MEDIUM, LEVEL_2 = MEDIUM, LEVEL_3 = MEDIUM, LEVEL_4 = MEDIUM)
          );


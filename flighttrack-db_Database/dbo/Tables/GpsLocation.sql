CREATE TABLE [dbo].[GpsLocation] (
    [GPSLocationID]        INT               IDENTITY (1, 1) NOT NULL,
    [lastUpdate]           DATETIME          CONSTRAINT [DF_GpsLocation_lastUpdate] DEFAULT (getdate()) NOT NULL,
    [latitude]             DECIMAL (10, 6)   NOT NULL,
    [longitude]            DECIMAL (10, 6)   NOT NULL,
    [speed]                INT               NULL,
    [distance]             INT               NULL,
    [gpsTime]              DATETIME          NULL,
    [gpsTimeOnly]          AS                (CONVERT([char](5),[gpsTime],(108))) PERSISTED,
    [accuracy]             INT               NULL,
    [eventType]            VARCHAR (50)      NULL,
    [extraInfo]            VARCHAR (255)     NULL,
    [onSessionPointNum]    INT               NOT NULL,
    [FlightID]             INT               NOT NULL,
    [SpeedMpC]             INT               NULL,
    [SpeedMph]             AS                (CONVERT([int],round([SpeedMpc]*(2.237),(0),(1)),(0))),
    [SpeedKnot]            AS                (CONVERT([int],round([SpeedMpc]*(1.94384),(0),(1)),(0))),
    [SpeedKmpH]            AS                (CONVERT([int],round([SpeedMpc]*(3.6),(0),(1)),(0))),
    [AltitudeM]            AS                (CONVERT([decimal],[extrainfo],(0))) PERSISTED,
    [DistanceToStartPoint] INT               NULL,
    [GeoLocation]          [sys].[geography] NULL,
    [AirportCode]          NVARCHAR (10)     NULL,
    [IsGeocoded]           BIT               CONSTRAINT [DF_GpsLocation_IsGeocoded] DEFAULT ((0)) NULL,
    [signalStrength]       INT               NULL,
    [AltitudeFt]           INT               NULL,
    [AreaID]               INT               NULL,
    CONSTRAINT [PK_GpsLocation] PRIMARY KEY NONCLUSTERED ([GPSLocationID] ASC),
    CONSTRAINT [FK_GpsLocation_Flight] FOREIGN KEY ([FlightID]) REFERENCES [dbo].[Flight] ([FlightID]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-Loc-FlId_Altit]
    ON [dbo].[GpsLocation]([GPSLocationID] ASC)
    INCLUDE([FlightID], [AltitudeFt]);


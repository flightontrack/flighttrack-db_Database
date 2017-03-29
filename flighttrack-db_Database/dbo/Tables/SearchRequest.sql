CREATE TABLE [dbo].[SearchRequest] (
    [SearchID]     INT          IDENTITY (1, 1) NOT NULL,
    [FlightDate]   DATETIME     NULL,
    [AirportID]    INT          NULL,
    [PilotID]      INT          NULL,
    [AircraftID]   INT          NULL,
    [AirportCode]  NCHAR (10)   NULL,
    [AcftRegNum]   VARCHAR (10) NULL,
    [AcftNumLocal] VARCHAR (50) NULL,
    [PilotCode]    VARCHAR (50) NULL,
    [FlightID]     INT          NULL,
    [AreaID]       INT          NULL
);


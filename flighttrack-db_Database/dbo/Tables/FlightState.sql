CREATE TABLE [dbo].[FlightState] (
    [FlightStateID]     INT          NOT NULL,
    [FlightStateName]   VARCHAR (50) NULL,
    [NextFlightStateID] INT          NULL,
    [CommandID]         INT          NULL,
    CONSTRAINT [PK_FlightState] PRIMARY KEY CLUSTERED ([FlightStateID] ASC)
);


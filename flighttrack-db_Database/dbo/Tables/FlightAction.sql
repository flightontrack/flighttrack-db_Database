CREATE TABLE [dbo].[FlightAction] (
    [FlightActionID]                    INT          NOT NULL,
    [ChecksumID]                        AS           (checksum([RequestID],[FlightStateID],[IsPattern],[IsAboveSpeedBottomTreshhold],[IsRoad],[IsMaxAllowedPointsReached])) PERSISTED,
    [Request]                           VARCHAR (50) NULL,
    [RequestID]                         INT          NULL,
    [FlightState]                       VARCHAR (50) NULL,
    [FlightStateID]                     INT          NULL,
    [IsAboveSpeedBottomTreshhold]       BIT          NULL,
    [IsPattern]                         BIT          NULL,
    [IsMaxAllowedPointsReached]         BIT          NULL,
    [IsRoad]                            BIT          NULL,
    [r_ResponseType]                    INT          NULL,
    [r_ResponseCommand]                 VARCHAR (10) NULL,
    [r_ResponseData]                    VARCHAR (50) NULL,
    [a_IsSetLocation]                   BIT          NULL,
    [a_IsCreateFlight]                  BIT          NULL,
    [a_IsUpdFlightStatus]               BIT          NULL,
    [a_IsUpdFlightStatus_FlightState]   VARCHAR (50) NULL,
    [a_IsUpdFlightStatus_FlightStateID] INT          NULL,
    [a_IsUpdFlightAttrib]               BIT          NULL,
    [isActive]                          INT          NULL,
    CONSTRAINT [PK_FlightAction] PRIMARY KEY CLUSTERED ([FlightActionID] ASC)
);


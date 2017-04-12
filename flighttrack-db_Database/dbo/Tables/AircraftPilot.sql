CREATE TABLE [dbo].[AircraftPilot] (
    [ID]           INT            IDENTITY (1, 1) NOT NULL,
    [AcftID]       INT            NOT NULL,
    [AcftNumLocal] NVARCHAR (50)  NULL,
    [AcftName]     NVARCHAR (100) NULL,
    [PilotID]      INT            NOT NULL,
	[CompanyID]		INT				NULL,
    [Created]      DATETIME       CONSTRAINT [DF__AircraftP__Creat__6EF57B66] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_AircraftPilot] PRIMARY KEY CLUSTERED ([ID] ASC)
);


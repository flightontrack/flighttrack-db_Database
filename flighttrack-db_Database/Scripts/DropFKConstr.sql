USE [flighttrack-db]
GO

ALTER TABLE [dbo].[GpsLocation] DROP CONSTRAINT [FK_GpsLocation_Flight]
GO

ALTER TABLE [dbo].[FlightController] DROP CONSTRAINT [FK_FlightController_Flight]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[FlightController]  WITH CHECK ADD  CONSTRAINT [FK_FlightController_Flight] FOREIGN KEY([FlightID])
REFERENCES [dbo].[Flight] ([FlightID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlightController] CHECK CONSTRAINT [FK_FlightController_Flight]
GO
ALTER TABLE [dbo].[GpsLocation]  WITH CHECK ADD  CONSTRAINT [FK_GpsLocation_Flight] FOREIGN KEY([FlightID])
REFERENCES [dbo].[Flight] ([FlightID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[GpsLocation] CHECK CONSTRAINT [FK_GpsLocation_Flight]
GO
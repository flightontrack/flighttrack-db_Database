truncate table [dbo].[DimAcftGroup]
INSERT INTO [dbo].[DimAcftGroup] ([GroupID], [GroupName],GroupType) VALUES (1, N'Urban Aviation','company')
INSERT INTO [dbo].[DimAcftGroup] ([GroupID], [GroupName],GroupType) VALUES (2, N'Thunderbirds','formation')

insert into AircraftGroup(AcftID,GroupID) values (2,1)
insert into AircraftGroup(AcftID,GroupID) values (8,1)
insert into AircraftGroup(AcftID,GroupID) values (9,1)
insert into AircraftGroup(AcftID,GroupID) values (7,2)
insert into AircraftGroup(AcftID,GroupID) values (8,2)




CREATE  VIEW [dbo].[vListPilot]
 
AS
SELECT 
	p.PilotID,
	PilotCode=coalesce(p.PilotName,p.PilotCode),
	c=COUNT_BIG(*)
FROM [dbo].[Flight] f
JOIN [dbo].Pilot p ON f.PilotID = p.PilotID
GROUP BY p.PilotID,p.PilotName,p.PilotCode
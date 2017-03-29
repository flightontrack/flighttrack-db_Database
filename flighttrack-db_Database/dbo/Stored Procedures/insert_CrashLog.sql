CREATE PROC [dbo].[insert_CrashLog]
           @CrashText VARCHAR(MAX) = NULL
AS
INSERT INTO [dbo].[CrashLog]
           (CrashText)
  OUTPUT INSERTED.CrashID
     VALUES (@CrashText)
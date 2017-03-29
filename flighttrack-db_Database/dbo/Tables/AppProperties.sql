CREATE TABLE [dbo].[AppProperties] (
    [PropertyID]    INT           NOT NULL,
    [PropertyKey]   VARCHAR (50)  NULL,
    [PropertyValue] VARCHAR (250) NULL,
    CONSTRAINT [PK_AppProperties] PRIMARY KEY CLUSTERED ([PropertyID] ASC)
);


CREATE TABLE [dbo].[Response] (
    [ResponseType]   VARCHAR (50) NOT NULL,
    [ResponseTypeID] INT          NOT NULL,
    [ResponseID]     INT          NOT NULL,
    [Response]       VARCHAR (50) NULL,
    CONSTRAINT [PK_Response] PRIMARY KEY CLUSTERED ([ResponseID] ASC)
);


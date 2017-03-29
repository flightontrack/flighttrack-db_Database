CREATE TABLE [dbo].[DimAcftRegistry] (
    [N-NUMBER]      VARCHAR (6)  NOT NULL,
    [SERIAL NUMBER] VARCHAR (32) NULL,
    [MFR]           VARCHAR (32) NULL,
    [YEAR MFR]      VARCHAR (4)  NULL,
    [MODEL]         VARCHAR (24) NULL,
    [AcftMMS]       AS           (isnull([MFR],'')+isnull(' '+[MODEL],'')) PERSISTED NOT NULL,
    CONSTRAINT [PK_DimAcftRegistry_1] PRIMARY KEY CLUSTERED ([N-NUMBER] ASC)
);


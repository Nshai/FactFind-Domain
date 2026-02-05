SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TFundDenorm]
(
    [FundId] [int] NOT NULL,
    [FundUnitId] [int] NOT NULL,
    [ComputedId] AS ( 'F' + CONVERT(varchar(10), FundUnitId) ) PERSISTED,
    [FundTypeId] [int] NOT NULL,
    [FundTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
    [Name] [varchar] (255) NULL,
    [SedolCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
    [MexCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
    [ISINCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
    [Citicode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
    [FundSectorId] [int] NULL,
    [FundSectorName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
    [Currency] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
    [UpdatedFg] [bit] NOT NULL CONSTRAINT [DF_TFundDenorm_UpdatedFg] DEFAULT (1),
    [APIRCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
    [Source] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
    [TickerCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
    [FeedFundCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFundDenorm] ADD CONSTRAINT [PK_TFundDenorm] PRIMARY KEY CLUSTERED  ([FundUnitId])
GO
CREATE NONCLUSTERED INDEX [IX_FundDenorm_ComputedId] ON [dbo].[TFundDenorm] ([ComputedId], [FundUnitId])
GO
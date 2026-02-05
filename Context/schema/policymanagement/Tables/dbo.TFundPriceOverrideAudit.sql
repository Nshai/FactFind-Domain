CREATE TABLE [dbo].[TFundPriceOverrideAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[FundId] [int] NOT NULL,
[FundTypeId] [int] NOT NULL,
[FromFeedFg] [bit] NOT NULL,
[PriceDate] [datetime] NULL,
[Price] [float] NULL,
[PriceUpdatedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[FundPriceOverrideId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFundPriceOverrideAudit] ADD CONSTRAINT [PK_TFundPriceOverrideAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

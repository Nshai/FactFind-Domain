CREATE TABLE [dbo].[TFundAudit_NotUsed]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FeedId] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Sedol] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[MexId] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Citicode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FundTypeId] [int] NOT NULL,
[SectorId] [int] NULL,
[ProviderId] [int] NULL,
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_TFundAudit_UpdatedDate] DEFAULT (getdate()),
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TFundAudit_CreatedDate] DEFAULT (getdate()),
[IndigoClientId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFundAudit_ConcurrencyId] DEFAULT ((1)),
[FundId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFundAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFundAudit_NotUsed] ADD CONSTRAINT [PK_TFundAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO

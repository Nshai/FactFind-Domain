CREATE TABLE [dbo].[TAtrAssetClassFundAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AtrAssetClassGuid] [uniqueidentifier] NULL,
[FundId] [int] NULL,
[FundTypeId] [int] NULL,
[FromFeed] [bit] NOT NULL,
[Recommended] [bit] NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrAssetClassFundAudit_ConcurrencyId] DEFAULT ((1)),
[AtrAssetClassFundId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrAssetClassFundAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrAssetClassFundAudit] ADD CONSTRAINT [PK_TAtrAssetClassFundAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrAssetClassFundAudit_AtrAssetClassFundId_ConcurrencyId] ON [dbo].[TAtrAssetClassFundAudit] ([AtrAssetClassFundId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

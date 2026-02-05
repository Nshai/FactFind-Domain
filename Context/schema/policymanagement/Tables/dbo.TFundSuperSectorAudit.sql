CREATE TABLE [dbo].[TFundSuperSectorAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) NOT NULL,
[IsArchived] [bit] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFundSuperSectorAudit_ConcurrencyId] DEFAULT ((1)),
[FundSuperSectorId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFundSuperSectorAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TFundSuperSectorAudit] ADD CONSTRAINT [PK_TFundSuperSectorAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFundSuperSectorAudit_FundSuperSectorId_ConcurrencyId] ON [dbo].[TFundSuperSectorAudit] ([FundSuperSectorId], [ConcurrencyId])
GO

CREATE TABLE [dbo].[TQuotePremiumAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Frequency] [int] NULL,
[Type] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[QuotePremiumId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQuotePremiumAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQuotePremiumAudit] ADD CONSTRAINT [PK_TQuotePremiumAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

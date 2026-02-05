CREATE TABLE [dbo].[TFundPanelRestrictedAudit]
(
[FundPanelRestrictedAuditId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[FundPanelRestrictedId] [nchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL
)
GO
ALTER TABLE [dbo].[TFundPanelRestrictedAudit] ADD CONSTRAINT [PK_TFundPanelRestrictedAudit] PRIMARY KEY CLUSTERED  ([FundPanelRestrictedAuditId])
GO

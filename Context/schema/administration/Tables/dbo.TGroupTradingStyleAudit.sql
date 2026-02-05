CREATE TABLE [dbo].[TGroupTradingStyleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGroupTradingStyleAudit_ConcurrencyId] DEFAULT ((1)),
[GroupId] [int] NOT NULL,
[IntegratedSystemId] [int] NOT NULL,
[TradingStyleId] [int] NULL,
[IsPropagate] [bit] NOT NULL,
[TenantId] [int] NOT NULL,
[GroupTradingStyleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF__TGroupTradingStyleAudit__StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TGroupTradingStyleAudit] ADD CONSTRAINT [PK_TGroupTradingStyleAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

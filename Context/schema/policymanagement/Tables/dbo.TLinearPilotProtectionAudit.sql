CREATE TABLE [dbo].[TLinearPilotProtectionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NULL,
[WaiverDeferedFg] [bit] NULL,
[IndexationFg] [bit] NULL,
[ConcurrencyId] [int] NULL,
[LinearPilotProtectionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLinearPilotProtectionAudit] ADD CONSTRAINT [PK_TLinearPilotProtectionAudit] PRIMARY KEY CLUSTERED  ([LinearPilotProtectionId])
GO
CREATE NONCLUSTERED INDEX [IX_TLinearPilotProtectionAudit_StampDateTime_LinearPilotProtectionId] ON [dbo].[TLinearPilotProtectionAudit] ([StampDateTime], [LinearPilotProtectionId])
GO

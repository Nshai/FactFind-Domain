CREATE TABLE [dbo].[TPolicyBusinessPurposeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PlanPurposeId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBus_ConcurrencyId_4__56] DEFAULT ((1)),
[PolicyBusinessPurposeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyBus_StampDateTime_5__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
PlanMigrationRef varchar(255)
)
GO
ALTER TABLE [dbo].[TPolicyBusinessPurposeAudit] ADD CONSTRAINT [PK_TPolicyBusinessPurposeAudit_6__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPolicyBusinessPurposeAudit_PolicyBusinessPurposeId_ConcurrencyId] ON [dbo].[TPolicyBusinessPurposeAudit] ([PolicyBusinessPurposeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

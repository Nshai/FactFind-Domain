CREATE TABLE [dbo].[TPolicyUnitValuationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyFundId] [int] NULL,
[UnitValue] [int] NULL,
[UnitValuationDate] [datetime] NULL,
[UpdatedByUserId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyUnitValuationAudit_ConcurrencyId] DEFAULT ((1)),
[PolicyUnitValuationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyUnitValuationAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPolicyUnitValuationAudit] ADD CONSTRAINT [PK_TPolicyUnitValuationAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPolicyUnitValuationAudit_PolicyUnitValuationId_ConcurrencyId] ON [dbo].[TPolicyUnitValuationAudit] ([PolicyUnitValuationId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

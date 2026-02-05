CREATE TABLE [dbo].[TDpGuidAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EntityId] [int] NOT NULL,
[DpGuidTypeId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TDpGuidAudit_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDpGuidAudit_ConcurrencyId] DEFAULT ((1)),
[DpGuidId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDpGuidAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDpGuidAudit] ADD CONSTRAINT [PK_TDpGuidAudit] PRIMARY KEY NONCLUSTERED  ([DpGuidId]) WITH (FILLFACTOR=80)
GO

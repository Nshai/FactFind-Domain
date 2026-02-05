CREATE TABLE [dbo].[TBankruptcyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[bankruptcyDischargedFg] [bit] NULL,
[bankruptcyDate] [datetime] NULL,
[bankruptcyApp1] [bit] NULL,
[bankruptcyApp2] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TBankruptcyAudit_ConcurrencyId] DEFAULT ((1)),
[BankruptcyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TBankruptcyAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TBankruptcyAudit] ADD CONSTRAINT [PK_TBankruptcyAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TBankruptcyAudit_BankruptcyId_ConcurrencyId] ON [dbo].[TBankruptcyAudit] ([BankruptcyId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

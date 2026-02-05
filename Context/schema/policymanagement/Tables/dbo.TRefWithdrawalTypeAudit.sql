CREATE TABLE [dbo].[TRefWithdrawalTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[WithdrawalName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[RefWithdrawalTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefWithdr_StampDateTime_1__52] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefWithdrawalTypeAudit] ADD CONSTRAINT [PK_TRefWithdrawalTypeAudit_2__52] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefWithdrawalTypeAudit_RefWithdrawalTypeId_ConcurrencyId] ON [dbo].[TRefWithdrawalTypeAudit] ([RefWithdrawalTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

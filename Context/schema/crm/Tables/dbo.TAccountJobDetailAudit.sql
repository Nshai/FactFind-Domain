CREATE TABLE [dbo].[TAccountJobDetailAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AccountJobDetailId] [int] NOT NULL,
[AccountId] [int] NOT NULL,
[JobTitle] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[EmployerCRMId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAccountJobDetailAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAccountJobDetailAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAccountJobDetailAudit] ADD CONSTRAINT [PK_TAccountJobDetailAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAccountJobDetailAudit_AccountJobDetailId_ConcurrencyId] ON [dbo].[TAccountJobDetailAudit] ([AccountJobDetailId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO

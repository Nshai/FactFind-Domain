CREATE TABLE [dbo].[TArrearExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[BeenInArrearsFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TArrearExtAudit_ConcurrencyId] DEFAULT ((1)),
[ArrearExtId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TArrearExtAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TArrearExtAudit] ADD CONSTRAINT [PK_TArrearExtAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TArrearExtAudit_ArrearExtId_ConcurrencyId] ON [dbo].[TArrearExtAudit] ([ArrearExtId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

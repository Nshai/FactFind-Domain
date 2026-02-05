CREATE TABLE [dbo].[TIVAExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[beenBancruptIVAFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIVAExtAudit_ConcurrencyId] DEFAULT ((1)),
[IVAExtId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIVAExtAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIVAExtAudit] ADD CONSTRAINT [PK_TIVAExtAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TIVAExtAudit_IVAExtId_ConcurrencyId] ON [dbo].[TIVAExtAudit] ([IVAExtId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

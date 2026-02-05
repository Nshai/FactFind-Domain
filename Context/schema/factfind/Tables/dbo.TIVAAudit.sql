CREATE TABLE [dbo].[TIVAAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ivaCurrentFg] [bit] NULL,
[ivaNoYears] [int] NULL,
[ivaDate] [datetime] NULL,
[ivaApp1] [bit] NULL,
[ivaApp2] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIVAAudit_ConcurrencyId] DEFAULT ((1)),
[IVAId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIVAAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIVAAudit] ADD CONSTRAINT [PK_TIVAAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TIVAAudit_IVAId_ConcurrencyId] ON [dbo].[TIVAAudit] ([IVAId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

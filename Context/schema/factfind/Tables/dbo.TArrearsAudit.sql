CREATE TABLE [dbo].[TArrearsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[arrDateFirst] [datetime] NULL,
[arrMissedNo] [int] NULL,
[arrStillNo] [int] NULL,
[arrDateClear] [datetime] NULL,
[arrWillBeClearedFg] [bit] NULL,
[arrApp1] [bit] NULL,
[arrApp2] [bit] NULL,
[arrOutstanding] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TArrearsAudit_ConcurrencyId] DEFAULT ((1)),
[ArrearsId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TArrearsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TArrearsAudit] ADD CONSTRAINT [PK_TArrearsAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TArrearsAudit_ArrearsId_ConcurrencyId] ON [dbo].[TArrearsAudit] ([ArrearsId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

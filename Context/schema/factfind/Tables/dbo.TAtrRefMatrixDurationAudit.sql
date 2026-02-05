CREATE TABLE [dbo].[TAtrRefMatrixDurationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [tinyint] NOT NULL,
[Starting] [tinyint] NULL,
[Ending] [tinyint] NULL,
[ConcurrencyId] [int] NULL,
[AtrRefMatrixDurationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrRefMatrixDurationAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrRefMatrixDurationAudit] ADD CONSTRAINT [PK_TAtrRefMatrixDurationAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrRefMatrixDurationAudit_AtrRefMatrixDurationId_ConcurrencyId] ON [dbo].[TAtrRefMatrixDurationAudit] ([AtrRefMatrixDurationId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

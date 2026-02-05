CREATE TABLE [dbo].[TTargetAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[PractCRMContactId] [int] NULL,
[TargetAmount] [float] NULL,
[Month] [tinyint] NULL,
[Year] [smallint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[TargetId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TTargetAud_StampDateTime_1__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTargetAudit] ADD CONSTRAINT [PK_TTargetAudit_2__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TTargetAudit_TargetId_ConcurrencyId] ON [dbo].[TTargetAudit] ([TargetId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

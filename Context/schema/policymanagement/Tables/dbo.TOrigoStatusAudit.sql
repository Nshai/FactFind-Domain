CREATE TABLE [dbo].[TOrigoStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[OrigoRef] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[RetiredFg] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOrigoStat_ConcurrencyId_1__56] DEFAULT ((1)),
[OrigoStatusId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOrigoStat_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOrigoStatusAudit] ADD CONSTRAINT [PK_TOrigoStatusAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TOrigoStatusAudit_OrigoStatusId_ConcurrencyId] ON [dbo].[TOrigoStatusAudit] ([OrigoStatusId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

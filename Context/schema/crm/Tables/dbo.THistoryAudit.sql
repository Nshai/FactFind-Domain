CREATE TABLE [dbo].[THistoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NULL,
[HistoryDate] [datetime] NULL,
[Notes] [varchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[Subject] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[RefHistoryTypeId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_THistoryAu_ConcurrencyId_1__56] DEFAULT ((1)),
[HistoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_THistoryAu_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[THistoryAudit] ADD CONSTRAINT [PK_THistoryAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_THistoryAudit_HistoryId_ConcurrencyId] ON [dbo].[THistoryAudit] ([HistoryId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

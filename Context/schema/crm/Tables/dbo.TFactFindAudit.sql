CREATE TABLE [dbo].[TFactFindAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[DocumentId] [int] NOT NULL,
[LatestDocVerId] [int] NOT NULL,
[VersionDate] [datetime] NOT NULL,
[CreatedByUserId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[FactFindId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFactFindA_StampDateTime_1__67] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFactFindAudit] ADD CONSTRAINT [PK_TFactFindAudit_2__67] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TFactFindAudit_FactFindId_ConcurrencyId] ON [dbo].[TFactFindAudit] ([FactFindId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

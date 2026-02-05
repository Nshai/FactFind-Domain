CREATE TABLE [dbo].[TRetiredAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[OccupationId] [int] NOT NULL,
[PensionIncome] [money] NULL,
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RetiredId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRetiredAu_StampDateTime_1__57] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRetiredAudit] ADD CONSTRAINT [PK_TRetiredAudit_2__57] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRetiredAudit_RetiredId_ConcurrencyId] ON [dbo].[TRetiredAudit] ([RetiredId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

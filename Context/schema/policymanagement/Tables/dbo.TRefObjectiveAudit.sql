CREATE TABLE [dbo].[TRefObjectiveAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ObjectiveName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[TargetValueFg] [tinyint] NULL,
[RetireFg] [tinyint] NULL,
[IndigoClientId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefObject_ConcurrencyId_1__56] DEFAULT ((1)),
[RefObjectiveId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefObject_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefObjectiveAudit] ADD CONSTRAINT [PK_TRefObjectiveAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefObjectiveAudit_RefObjectiveId_ConcurrencyId] ON [dbo].[TRefObjectiveAudit] ([RefObjectiveId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

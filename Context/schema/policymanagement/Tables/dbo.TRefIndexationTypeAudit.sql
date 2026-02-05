CREATE TABLE [dbo].[TRefIndexationTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndexationTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrigoRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FixedAmountFg] [tinyint] NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefIndexationTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefIndexa_StampDateTime_1__52] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefIndexationTypeAudit] ADD CONSTRAINT [PK_TRefIndexationTypeAudit_2__52] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefIndexationTypeAudit_RefIndexationTypeId_ConcurrencyId] ON [dbo].[TRefIndexationTypeAudit] ([RefIndexationTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

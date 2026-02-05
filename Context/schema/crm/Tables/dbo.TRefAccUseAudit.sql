CREATE TABLE [dbo].[TRefAccUseAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[AccountUseDesc] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefAccUseId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefAccUse_StampDateTime_1__54] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefAccUseAudit] ADD CONSTRAINT [PK_TRefAccUseAudit_2__54] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefAccUseAudit_RefAccUseId_ConcurrencyId] ON [dbo].[TRefAccUseAudit] ([RefAccUseId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

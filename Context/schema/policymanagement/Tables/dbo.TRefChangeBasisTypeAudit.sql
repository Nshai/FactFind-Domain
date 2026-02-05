CREATE TABLE [dbo].[TRefChangeBasisTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ChangeBasisTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[OrigoRef] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefChangeBasisTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefChange_StampDateTime_1__63] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefChangeBasisTypeAudit] ADD CONSTRAINT [PK_TRefChangeBasisTypeAudit_2__63] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefChangeBasisTypeAudit_RefChangeBasisTypeId_ConcurrencyId] ON [dbo].[TRefChangeBasisTypeAudit] ([RefChangeBasisTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

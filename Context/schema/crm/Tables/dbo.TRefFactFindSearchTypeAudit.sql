CREATE TABLE [dbo].[TRefFactFindSearchTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[SearchTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AllPlanTypes] [bit] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefFactFindSearchTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefFactFindSearchTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefFactFindSearchTypeAudit] ADD CONSTRAINT [PK_TRefFactFindSearchTypeAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefFactFindSearchTypeAudit_FactFindSearchAuditId_ConcurrencyId] ON [dbo].[TRefFactFindSearchTypeAudit] ([RefFactFindSearchTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

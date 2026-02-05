CREATE TABLE [dbo].[TFactFindSearchAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefFactFindSearchTypeId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[FactFindSearchId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFactFindSearchAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFactFindSearchAudit] ADD CONSTRAINT [PK_TFactFindSearchAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TFactFindSearchAudit_FactFindSearchId_ConcurrencyId] ON [dbo].[TFactFindSearchAudit] ([FactFindSearchId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

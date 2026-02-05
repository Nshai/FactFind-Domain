CREATE TABLE [dbo].[TRefWebServiceAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[URL] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[ClassName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[MethodName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[NamedDataSource] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[DenyAccess] [bit] NOT NULL CONSTRAINT [DF_TRefWebServiceAudit_DenyAccess] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefWebServiceAudit_ConcurrencyId] DEFAULT ((1)),
[RefWebServiceId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefWebServiceAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefWebServiceAudit] ADD CONSTRAINT [PK_TRefWebServiceAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefWebServiceAudit_RefWebServiceId_ConcurrencyId] ON [dbo].[TRefWebServiceAudit] ([RefWebServiceId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

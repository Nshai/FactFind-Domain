CREATE TABLE [dbo].[TIndigoClientSibAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[GroupId] [int] NULL,
[Sib] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[IsAgencyCode] [bit] NOT NULL CONSTRAINT [DF_TIndigoClientSibAudit_IsAgencyCode] DEFAULT ((0)),
[Guid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndigoClientSibAudit_ConcurrencyId] DEFAULT ((1)),
[IndigoClientSibId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIndigoClientSibAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIndigoClientSibAudit] ADD CONSTRAINT [PK_TIndigoClientSibAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TIndigoClientSibAudit_IndigoClientSibId_ConcurrencyId] ON [dbo].[TIndigoClientSibAudit] ([IndigoClientSibId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

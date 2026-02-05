CREATE TABLE [dbo].[TIndigoClientSibCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Guid] [uniqueidentifier] NOT NULL,
[IndigoClientSibId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[GroupId] [int] NULL,
[Sib] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[IsAgencyCode] [bit] NOT NULL CONSTRAINT [DF_TIndigoClientSibCombinedAudit_IsAgencyCode] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndigoClientSibCombinedAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIndigoClientSibCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIndigoClientSibCombinedAudit] ADD CONSTRAINT [PK_TIndigoClientSibCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO

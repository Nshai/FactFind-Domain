CREATE TABLE [dbo].[TFactFindTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[CRMContactType] [tinyint] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFactFindTypeAudit_ConcurrencyId] DEFAULT ((1)),
[FactFindTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFactFindTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFactFindTypeAudit] ADD CONSTRAINT [PK_TFactFindTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO

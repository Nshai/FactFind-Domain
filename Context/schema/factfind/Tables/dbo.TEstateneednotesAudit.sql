CREATE TABLE [dbo].[TEstateneednotesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[estateneednotes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[EstateneednotesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEstatene__Concu__7F01C5FD] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEstateneednotesAudit] ADD CONSTRAINT [PK_TEstateneednotesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

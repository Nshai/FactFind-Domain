CREATE TABLE [dbo].[TCurrentProtectionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Notes] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[CurrentProtectionId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TCurrentP__Concu__52EE3995] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCurrentProtectionAudit] ADD CONSTRAINT [PK_TCurrentProtectionAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

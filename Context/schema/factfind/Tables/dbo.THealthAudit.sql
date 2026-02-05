CREATE TABLE [dbo].[THealthAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[GoodHealth] [bit] NULL,
[HealthComments] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[HealthId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__THealthAu__Concu__4999D985] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[THealthAudit] ADD CONSTRAINT [PK_THealthAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

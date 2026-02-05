CREATE TABLE [dbo].[TFactFindAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId1] [int] NOT NULL,
[CRMContactId2] [int] NULL,
[FactFindTypeId] [int] NULL,
[IndigoClientId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFactFindAudit_ConcurrencyId] DEFAULT ((1)),
[FactFindId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFactFindAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFactFindAudit] ADD CONSTRAINT [PK_TFactFindAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO

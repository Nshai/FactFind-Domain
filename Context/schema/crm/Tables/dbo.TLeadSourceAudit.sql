CREATE TABLE [dbo].[TLeadSourceAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LeadTypeId] [int] NOT NULL,
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Reference] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Cost] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLeadSourceAudit_ConcurrencyId] DEFAULT ((1)),
[LeadSourceId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TLeadSourceAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLeadSourceAudit] ADD CONSTRAINT [PK_TLeadSourceAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO

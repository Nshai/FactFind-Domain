CREATE TABLE [dbo].[TLeadAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[LeadSourceId] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLeadAudit_ConcurrencyId] DEFAULT ((1)),
[LeadId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TLeadAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
[IntroducerEmployeeId] [int] NULL,
[IntroducerBranchId] [int] NULL,
[IndividualName] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TLeadAudit] ADD CONSTRAINT [PK_TLeadAudit_AuditId] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TLeadAudit_CRMContactId] ON [dbo].[TLeadAudit] ([CRMContactId])
GO
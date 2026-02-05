CREATE TABLE [dbo].[TLeadImportResultAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LeadImportId] [int] NOT NULL,
[LineNumber] [int] NOT NULL,
[Descriptor] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[Result] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[LeadId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLeadImportResultAudit_ConcurrencyId] DEFAULT ((1)),
[LeadImportResultId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TLeadImportResultAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLeadImportResultAudit] ADD CONSTRAINT [PK_TLeadImportResultAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO

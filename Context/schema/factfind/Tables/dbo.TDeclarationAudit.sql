CREATE TABLE [dbo].[TDeclarationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[TOBDate] [datetime] NULL,
[TOBVersion] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CostKeyfacts] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[ServicesKeyFacts] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[CompletedDate] [datetime] NULL,
[IDCheckedDate] [datetime] NULL,
[DeclarationDate] [datetime] NULL,
[TaskId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDeclarationAudit_ConcurrencyId] DEFAULT ((1)),
[DeclarationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDeclarationAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[DateTermsOfBusinessIssued] [datetime] NULL,
[DateTermsOfRefundsIssued] [datetime] NULL,
[DisclosureDocumentType] [varchar] (64) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDeclarationAudit] ADD CONSTRAINT [PK_TDeclarationAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TDeclarationAudit_DeclarationId_ConcurrencyId] ON [dbo].[TDeclarationAudit] ([DeclarationId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

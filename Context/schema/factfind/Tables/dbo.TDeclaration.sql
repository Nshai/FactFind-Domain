CREATE TABLE [dbo].[TDeclaration]
(
[DeclarationId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[TOBDate] [datetime] NULL,
[TOBVersion] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CostKeyfacts] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[ServicesKeyFacts] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[CompletedDate] [datetime] NULL,
[IDCheckedDate] [datetime] NULL,
[DeclarationDate] [datetime] NULL,
[TaskId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDeclaration_ConcurrencyId] DEFAULT ((1)),
[DateTermsOfBusinessIssued] [datetime] NULL,
[DateTermsOfRefundsIssued] [datetime] NULL,
[DisclosureDocumentType] [varchar] (64) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDeclaration] ADD CONSTRAINT [PK_TDeclaration] PRIMARY KEY NONCLUSTERED  ([DeclarationId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX IX_TDeclaration_CRMContactId ON [dbo].[TDeclaration] ([CRMContactId]) with (online = on, sort_in_tempdb = on)
GO
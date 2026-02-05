CREATE TABLE [dbo].[TPractitionerQueryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[PractitionerId] [int] NOT NULL,
[PolicyBusinessId] [int] NULL,
[FeeId] [int] NULL,
[RetainerId] [int] NULL,
[QueryType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ExpectedFCI] [money] NULL,
[StatementDate] [datetime] NULL,
[StatementAmount] [money] NULL,
[StatementRefNumber] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[StatementItemAmount] [money] NULL,
[ProviderName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ClientName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[PolicyNumber] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CashReceiptDate] [datetime] NULL,
[FeeRetainerAmount] [money] NULL,
[PractitionerNotes] [varchar] (3000) COLLATE Latin1_General_CI_AS NULL,
[SupportNotes] [varchar] (3000) COLLATE Latin1_General_CI_AS NULL,
[QueryStatus] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[LastUpdateUserId] [int] NOT NULL,
[LastUpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_TPractitio_LastUpdatedDate_4__56] DEFAULT (getdate()),
[SubmittedDate] [datetime] NULL,
[IsSubmitted] [bit] NOT NULL CONSTRAINT [DF_TPractitio_IsSubmitted_3__56] DEFAULT ((0)),
[_ParentId] [int] NULL,
[_ParentTable] [varchar] (64) COLLATE Latin1_General_CI_AS NULL,
[_ParentDB] [varchar] (64) COLLATE Latin1_General_CI_AS NULL,
[_OwnerId] [varchar] (64) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPractitio_ConcurrencyId_2__56] DEFAULT ((1)),
[PractitionerQueryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPractitio_StampDateTime_5__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPractitionerQueryAudit] ADD CONSTRAINT [PK_TPractitionerQueryAudit_6__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPractitionerQueryAudit_PractitionerQueryId_ConcurrencyId] ON [dbo].[TPractitionerQueryAudit] ([PractitionerQueryId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

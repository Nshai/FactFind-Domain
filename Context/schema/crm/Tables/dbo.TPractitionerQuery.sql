CREATE TABLE [dbo].[TPractitionerQuery]
(
[PractitionerQueryId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[PractitionerId] [int] NOT NULL,
[PolicyBusinessId] [int] NULL,
[FeeId] [int] NULL,
[RetainerId] [int] NULL,
[QueryType] [varchar] (50)  NULL,
[ExpectedFCI] [money] NULL,
[StatementDate] [datetime] NULL,
[StatementAmount] [money] NULL,
[StatementRefNumber] [varchar] (50)  NULL,
[StatementItemAmount] [money] NULL,
[ProviderName] [varchar] (50)  NULL,
[ClientName] [varchar] (50)  NULL,
[PolicyNumber] [varchar] (50)  NULL,
[CashReceiptDate] [datetime] NULL,
[FeeRetainerAmount] [money] NULL,
[PractitionerNotes] [varchar] (3000)  NULL,
[SupportNotes] [varchar] (3000)  NULL,
[QueryStatus] [varchar] (50)  NULL,
[LastUpdateUserId] [int] NOT NULL,
[LastUpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_TPractitionerQuery_LastUpdatedDate] DEFAULT (getdate()),
[SubmittedDate] [datetime] NULL,
[IsSubmitted] [bit] NOT NULL CONSTRAINT [DF_TPractitionerQuery_IsSubmitted] DEFAULT ((0)),
[_ParentId] [int] NULL,
[_ParentTable] [varchar] (64)  NULL,
[_ParentDb] [varchar] (64)  NULL,
[_OwnerId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPractitionerQuery_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPractitionerQuery] ADD CONSTRAINT [PK_TPractitionerQuery] PRIMARY KEY NONCLUSTERED  ([PractitionerQueryId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPractitionerQuery_PractitionerId] ON [dbo].[TPractitionerQuery] ([PractitionerId])
GO
ALTER TABLE [dbo].[TPractitionerQuery] WITH CHECK ADD CONSTRAINT [FK_TPractitionerQuery_PractitionerId_PractitionerId] FOREIGN KEY ([PractitionerId]) REFERENCES [dbo].[TPractitioner] ([PractitionerId])
GO

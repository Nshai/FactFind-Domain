CREATE TABLE [dbo].[TExpenditureDetailAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ConcurrencyId] [int] NULL,
[ExpenditureId] [int] NULL,
[CRMContactId] [int] NULL,
[RefExpenditureTypeId] [int] NULL,
[NetMonthlyAmount] [money] NULL,
[UserDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsConsolidated] [bit] NULL,
[IsLiabilityToBeRepaid] [bit] NULL,
[ExpenditureDetailId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TExpenditureDetailAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Frequency] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId2] [int] NULL,
[PolicyBusinessId] [int] NULL,
[ContributionId] [int] NULL,
[StartDate] [date] NULL,
[EndDate] [date] NULL,
[NetAmount] [money] NULL
)
GO
ALTER TABLE [dbo].[TExpenditureDetailAudit] ADD CONSTRAINT [PK_TExpenditureDetailAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TExpenditureDetailAudit_ExpenditureDetailId_ConcurrencyId] ON [dbo].[TExpenditureDetailAudit] ([ExpenditureDetailId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO

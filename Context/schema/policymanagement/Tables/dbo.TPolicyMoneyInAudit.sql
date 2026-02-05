CREATE TABLE [dbo].[TPolicyMoneyInAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Amount] [money] NULL,
[EscalationPercentage] [decimal] (5, 2) NULL,
[RefFrequencyId] [int] NOT NULL,
[StartDate] [datetime] NULL,
[PolicyBusinessId] [int] NOT NULL,
[RefTaxBasisId] [int] NULL,
[RefTaxYearId] [int] NULL,
[RefContributionTypeId] [int] NULL,
[RefContributorTypeId] [int] NULL,
[CurrentFg] [bit] NULL,
[RefEscalationTypeId] [int] NULL,
[SalaryPercentage] [decimal] (5, 2) NULL,
[StopDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyMon_ConcurrencyId_1__56] DEFAULT ((1)),
[PolicyMoneyInId] [int] NOT NULL,
[IsInitialFee] [bit] NULL,
[IsOngoingFee] [bit] NULL,
[IsCreatedBySystem] [bit] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyMon_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ContributionMigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Note] [varchar](250) NULL,
[EmploymentId] [int] NULL,
[RefTransferTypeId] [int] NULL,
[IsFullTransfer] [bit] NULL,
[HasSafeguardedBenefit] [bit] NULL
)
GO
ALTER TABLE [dbo].[TPolicyMoneyInAudit] ADD CONSTRAINT [PK_TPolicyMoneyInAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPolicyMoneyInAudit_PolicyMoneyInId_ConcurrencyId] ON [dbo].[TPolicyMoneyInAudit] ([PolicyMoneyInId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

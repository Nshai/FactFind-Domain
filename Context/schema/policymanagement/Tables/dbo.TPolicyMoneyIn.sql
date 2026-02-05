CREATE TABLE [dbo].[TPolicyMoneyIn]
(
[PolicyMoneyInId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
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
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyMon_ConcurrencyId_1__63] DEFAULT ((1)),
[IsInitialFee] [bit] NULL,
[IsOngoingFee] [bit] NULL,
[IsCreatedBySystem] [bit] NOT NULL CONSTRAINT [DF_TPolicyMoneyIn_IsCreatedBySystem] DEFAULT ((0)),
[ContributionMigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Note] [varchar](250) NULL,
[EmploymentId] [int] NULL,
[RefTransferTypeId] [int] NULL,
[IsFullTransfer] [bit] NULL,
[HasSafeguardedBenefit] [bit] NULL
)
GO
ALTER TABLE [dbo].[TPolicyMoneyIn] ADD CONSTRAINT [PK_TPolicyMoneyIn_9__63] PRIMARY KEY NONCLUSTERED  ([PolicyMoneyInId]) WITH (FILLFACTOR=90)
GO
ALTER TABLE [dbo].[TPolicyMoneyIn] ADD CONSTRAINT [DF_TPolicyMoneyIn_IsInitialFee]  DEFAULT ((1)) FOR [IsInitialFee]
GO
ALTER TABLE [dbo].[TPolicyMoneyIn] ADD CONSTRAINT [DF_TPolicyMoneyIn_IsOngoingFee]  DEFAULT ((1)) FOR [IsOngoingFee]
GO
ALTER TABLE [dbo].[TPolicyMoneyIn] ADD CONSTRAINT [FK_TPolicyMoneyIn_RefTaxBasisId_RefTaxBasisId] FOREIGN KEY ([RefTaxBasisId]) REFERENCES [dbo].[TRefTaxBasis] ([RefTaxBasisId])
GO
ALTER TABLE [dbo].[TPolicyMoneyIn] ADD CONSTRAINT [FK_TPolicyMoneyIn_RefTransferTypeId_RefTransferTypeId] FOREIGN KEY ([RefTransferTypeId]) REFERENCES [dbo].[TRefTransferType] ([RefTransferTypeId])
GO
CREATE CLUSTERED INDEX [IDX1_TPolicyMoneyIn_PolicyBusinessId] ON [dbo].[TPolicyMoneyIn] ([PolicyBusinessId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyMoneyIn_RefContributionTypeId] ON [dbo].[TPolicyMoneyIn] ([RefContributionTypeId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyMoneyIn_RefContributorTypeId] ON [dbo].[TPolicyMoneyIn] ([RefContributorTypeId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyMoneyIn_RefFrequencyId] ON [dbo].[TPolicyMoneyIn] ([RefFrequencyId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyMoneyIn_RefTaxBasisId] ON [dbo].[TPolicyMoneyIn] ([RefTaxBasisId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyMoneyIn_RefTaxYearId] ON [dbo].[TPolicyMoneyIn] ([RefTaxYearId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyMoneyIn_ContributionMigrationRef_INCL] ON [dbo].[TPolicyMoneyIn] ([ContributionMigrationRef]) INCLUDE ([PolicyMoneyInId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyMoneyIn_RefTransferTypeId] ON [dbo].[TPolicyMoneyIn] ([RefTransferTypeId]) WITH (FILLFACTOR=90)
GO
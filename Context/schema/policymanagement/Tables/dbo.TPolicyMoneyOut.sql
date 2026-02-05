CREATE TABLE [dbo].[TPolicyMoneyOut]
(
[PolicyMoneyOutId] [int] NOT NULL IDENTITY(1, 1),
[PolicyOwnerId] [int] NULL,
[PolicyBusinessId] [int] NOT NULL,
[BeneficiaryCRMContactId] [int] NULL,
[BeneficiaryPercentage] [decimal] (5, 2) NULL,
[Amount] [money] NULL,
[RefBenefitPaymentTypeId] [int] NULL,
[SalaryMultiple] [tinyint] NULL,
[RefRiskEventTypeId] [int] NULL,
[PaymentStartDate] [datetime] NULL,
[PaymentStopDate] [datetime] NULL,
[RefFrequencyId] [int] NULL,
[RefIndexationTypeId] [int] NULL,
[EscalationPercentage] [decimal] (5, 2) NULL,
[AssuredCRMContactId1] [int] NULL,
[AssuredCRMContactId2] [int] NULL,
[DeferredWeeks] [int] NULL,
[AssignedCRMContactId] [int] NULL,
[RefPaymentBasisTypeId] [int] NULL,
[PaymentBasisPercentage] [decimal] (5, 2) NULL,
[GuaranteedPeriodMonths] [int] NULL,
[RefWithdrawalBasisTypeId] [int] NULL,
[RefWithdrawalTypeId] [int] NULL,
[RefEscalationTypeId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyMoneyOut_ConcurrencyId] DEFAULT ((1)),
[TransferToPolicyMoneyInId] [int] NULL,
[SpousesOrDependentsPercentage] [decimal] (5, 2) NULL,
[IsOverlap] [bit] NULL,
[IsWithProportion] [bit] NULL,
[RefPaymentBasisId] [int] NULL,
[GuaranteedPeriod] [int] NULL,
[IsCreatedBySystem] [bit] NOT NULL CONSTRAINT [DF_TPolicyMoneyOut_IsCreatedBySystem] DEFAULT ((0)),
[WithdrawalMigrationRef] [varchar] (255)  NULL,
[Note] [varchar](250) NULL,
RefTransferTypeId [INT] NULL,
IsFullTransfer [BIT] NULL,
RefArrangementTypeId [INT] NULL,
RefWithdrawalSubTypeId [INT] NULL,
TaxableValue [decimal] (10, 2) NULL,
TaxFreeValue [decimal] (10, 2) NULL,
CrystallizedAmount [decimal] (10, 2) NULL
)
GO
ALTER TABLE [dbo].[TPolicyMoneyOut] ADD CONSTRAINT [PK_TPolicyMoneyOut] PRIMARY KEY NONCLUSTERED  ([PolicyMoneyOutId])
GO
CREATE CLUSTERED INDEX [IDX1_TPolicyMoneyOut_PolicyBusinessId] ON [dbo].[TPolicyMoneyOut] ([PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyMoneyOut_RefBenefitPaymentTypeId] ON [dbo].[TPolicyMoneyOut] ([RefBenefitPaymentTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyMoneyOut_RefFrequencyId] ON [dbo].[TPolicyMoneyOut] ([RefFrequencyId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyMoneyOut_RefIndexationTypeId] ON [dbo].[TPolicyMoneyOut] ([RefIndexationTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyMoneyOut_RefPaymentBasisTypeId] ON [dbo].[TPolicyMoneyOut] ([RefPaymentBasisTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyMoneyOut_RefRiskEventTypeId] ON [dbo].[TPolicyMoneyOut] ([RefRiskEventTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyMoneyOut_RefWithdrawalBasisTypeId] ON [dbo].[TPolicyMoneyOut] ([RefWithdrawalBasisTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyMoneyOut_RefWithdrawalTypeId] ON [dbo].[TPolicyMoneyOut] ([RefWithdrawalTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TPolicyMoneyOut_TransferToPolicyMoneyInId] ON [dbo].[TPolicyMoneyOut] ([TransferToPolicyMoneyInId])
GO
CREATE NONCLUSTERED INDEX [IX_TPolicyMoneyOut_WithdrawalMigrationRef_INCL] ON [dbo].[TPolicyMoneyOut] ([WithdrawalMigrationRef]) INCLUDE (PolicyMoneyOutId)
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyMoneyOut_RefTransferTypeId] ON [dbo].[TPolicyMoneyOut]([RefTransferTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyMoneyOut_RefArrangementTypeId] ON [dbo].[TPolicyMoneyOut]([RefArrangementTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyMoneyOut_RefWithdrawalSubTypeId] ON [dbo].[TPolicyMoneyOut]([RefWithdrawalSubTypeId])
GO
ALTER TABLE [dbo].[TPolicyMoneyOut] WITH CHECK ADD CONSTRAINT [FK_TPolicyMoneyOut_PolicyBusinessId_PolicyBusinessId] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TPolicyMoneyOut] ADD CONSTRAINT [FK_TPolicyMoneyOut_RefBenefitPaymentTypeId_RefBenefitPaymentTypeId] FOREIGN KEY ([RefBenefitPaymentTypeId]) REFERENCES [dbo].[TRefBenefitPaymentType] ([RefBenefitPaymentTypeId])
GO
ALTER TABLE [dbo].[TPolicyMoneyOut] ADD CONSTRAINT [FK_TPolicyMoneyOut_RefFrequencyId_RefFrequencyId] FOREIGN KEY ([RefFrequencyId]) REFERENCES [dbo].[TRefFrequency] ([RefFrequencyId])
GO
ALTER TABLE [dbo].[TPolicyMoneyOut] ADD CONSTRAINT [FK_TPolicyMoneyOut_RefIndexationTypeId_RefIndexationTypeId] FOREIGN KEY ([RefIndexationTypeId]) REFERENCES [dbo].[TRefIndexationType] ([RefIndexationTypeId])
GO
ALTER TABLE [dbo].[TPolicyMoneyOut] ADD CONSTRAINT [FK_TPolicyMoneyOut_RefPaymentBasisId_RefPaymentBasisId] FOREIGN KEY ([RefPaymentBasisId]) REFERENCES [dbo].[TRefPaymentBasis] ([RefPaymentBasisId])
GO
ALTER TABLE [dbo].[TPolicyMoneyOut] ADD CONSTRAINT [FK_TPolicyMoneyOut_RefPaymentBasisTypeId_RefPaymentBasisTypeId] FOREIGN KEY ([RefPaymentBasisTypeId]) REFERENCES [dbo].[TRefPaymentBasisType] ([RefPaymentBasisTypeId])
GO
ALTER TABLE [dbo].[TPolicyMoneyOut] ADD CONSTRAINT [FK_TPolicyMoneyOut_RefRiskEventTypeId_RefRiskEventTypeId] FOREIGN KEY ([RefRiskEventTypeId]) REFERENCES [dbo].[TRefRiskEventType] ([RefRiskEventTypeId])
GO
ALTER TABLE [dbo].[TPolicyMoneyOut] ADD CONSTRAINT [FK_TPolicyMoneyOut_RefWithdrawalBasisTypeId_RefWithdrawalBasisTypeId] FOREIGN KEY ([RefWithdrawalBasisTypeId]) REFERENCES [dbo].[TRefWithdrawalBasisType] ([RefWithdrawalBasisTypeId])
GO
ALTER TABLE [dbo].[TPolicyMoneyOut] ADD CONSTRAINT [FK_TPolicyMoneyOut_RefWithdrawalTypeId_RefWithdrawalTypeId] FOREIGN KEY ([RefWithdrawalTypeId]) REFERENCES [dbo].[TRefWithdrawalType] ([RefWithdrawalTypeId])
GO
ALTER TABLE [dbo].[TPolicyMoneyOut ]  WITH CHECK ADD  CONSTRAINT [FK_TPolicyMoneyOut_RefTransferTypeId_RefTransferTypeId] FOREIGN KEY([RefTransferTypeId])
REFERENCES [dbo].[TRefTransferType] ([RefTransferTypeId])
GO
ALTER TABLE [dbo].[TPolicyMoneyOut ] CHECK CONSTRAINT [FK_TPolicyMoneyOut_RefTransferTypeId_RefTransferTypeId]
GO
ALTER TABLE [dbo].[TPolicyMoneyOut ]  WITH CHECK ADD  CONSTRAINT [FK_TPolicyMoneyOut_RefArrangementTypeId_RefArrangementTypeId] FOREIGN KEY([RefArrangementTypeId])
REFERENCES [dbo].[TRefArrangementType] ([RefArrangementTypeId])
GO
ALTER TABLE [dbo].[TPolicyMoneyOut ] CHECK CONSTRAINT [FK_TPolicyMoneyOut_RefArrangementTypeId_RefArrangementTypeId]
GO
ALTER TABLE [dbo].[TPolicyMoneyOut ]  WITH CHECK ADD  CONSTRAINT [FK_TPolicyMoneyOut_RefWithdrawalSubTypeId_RefWithdrawalSubTypeId] FOREIGN KEY([RefWithdrawalSubTypeId])
REFERENCES [dbo].[TRefWithdrawalSubType] ([RefWithdrawalSubTypeId])
GO
ALTER TABLE [dbo].[TPolicyMoneyOut ] CHECK CONSTRAINT [FK_TPolicyMoneyOut_RefWithdrawalSubTypeId_RefWithdrawalSubTypeId]
GO
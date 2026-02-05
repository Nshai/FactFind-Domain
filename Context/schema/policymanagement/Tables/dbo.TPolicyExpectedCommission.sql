CREATE TABLE [dbo].[TPolicyExpectedCommission]
(
[PolicyExpectedCommissionId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[RefCommissionTypeId] [int] NOT NULL,
[RefPaymentDueTypeId] [int] NOT NULL,
[RefFrequencyId] [int] NULL,
[ChargingPeriodMonths] [tinyint] NULL,
[ExpectedAmount] [money] NULL,
[ExpectedStartDate] [datetime] NULL,
[ExpectedCommissionType] [bit] NOT NULL,
[ParentPolicyExpectedCommissionId] [int] NULL,
[PercentageFund] [decimal] (18, 0) NULL,
[Notes] [varchar] (50)  NULL,
[ChangedByUser] [int] NULL,
[PreDiscountAmount] [money] NULL,
[DiscountReasonId] [int] NULL,
[_CreatedByUserId] [int] NULL,
[_CreatedDate] [datetime] NULL,
[_LastUpdatedByUserId] [int] NULL,
[_LastUpdatedDate] [datetime] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyExpectedCommission_ConcurrencyId] DEFAULT ((1)),
PlanMigrationRef varchar(255) null,
CommissionMigrationRef varchar(255) null,
[ChargingType] [varchar] (50)  NULL,
[ExpectedPercentage] [decimal] (18, 2) NULL,
[DueDate] [datetime] NULL,
[EndsOn] [date] NULL
)
GO
ALTER TABLE [dbo].[TPolicyExpectedCommission] ADD CONSTRAINT [PK_TPolicyExpectedCommission] PRIMARY KEY NONCLUSTERED  ([PolicyExpectedCommissionId])
GO
CREATE CLUSTERED INDEX [IDX1_TPolicyExpectedCommission_PolicyBusinessId] ON [dbo].[TPolicyExpectedCommission] ([PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyExpectedCommission_RefCommissionTypeId] ON [dbo].[TPolicyExpectedCommission] ([RefCommissionTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyExpectedCommission_RefFrequencyId] ON [dbo].[TPolicyExpectedCommission] ([RefFrequencyId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyExpectedCommission_RefPaymentDueTypeId] ON [dbo].[TPolicyExpectedCommission] ([RefPaymentDueTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyExpectedCommission_ParentPolicyExpectedCommissionId] ON [dbo].[TPolicyExpectedCommission] ([ParentPolicyExpectedCommissionId])
GO
ALTER TABLE [dbo].[TPolicyExpectedCommission] WITH CHECK ADD CONSTRAINT [FK_TPolicyExpectedCommission_DiscountReasonId_DiscountReasonId] FOREIGN KEY ([DiscountReasonId]) REFERENCES [dbo].[TDiscountReason] ([DiscountReasonId])
GO
ALTER TABLE [dbo].[TPolicyExpectedCommission] WITH CHECK ADD CONSTRAINT [FK_TPolicyExpectedCommission_PolicyBusinessId_PolicyBusinessId] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TPolicyExpectedCommission] WITH CHECK ADD CONSTRAINT [FK_TPolicyExpectedCommission_RefCommissionTypeId_RefCommissionTypeId] FOREIGN KEY ([RefCommissionTypeId]) REFERENCES [dbo].[TRefCommissionType] ([RefCommissionTypeId])
GO
ALTER TABLE [dbo].[TPolicyExpectedCommission] WITH CHECK ADD CONSTRAINT [FK_TPolicyExpectedCommission_RefFrequencyId_RefFrequencyId] FOREIGN KEY ([RefFrequencyId]) REFERENCES [dbo].[TRefFrequency] ([RefFrequencyId])
GO
ALTER TABLE [dbo].[TPolicyExpectedCommission] WITH CHECK ADD CONSTRAINT [FK_TPolicyExpectedCommission_RefPaymentDueTypeId_RefPaymentDueTypeId] FOREIGN KEY ([RefPaymentDueTypeId]) REFERENCES [dbo].[TRefPaymentDueType] ([RefPaymentDueTypeId])
GO

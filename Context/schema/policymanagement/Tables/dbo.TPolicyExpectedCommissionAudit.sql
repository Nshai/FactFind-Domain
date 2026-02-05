CREATE TABLE [dbo].[TPolicyExpectedCommissionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PolicyBusinessId] [int] NULL,
[RefCommissionTypeId] [int] NULL,
[RefPaymentDueTypeId] [int] NULL,
[RefFrequencyId] [int] NULL,
[ChargingPeriodMonths] [tinyint] NULL,
[ExpectedAmount] [money] NULL,
[ExpectedStartDate] [datetime] NULL,
[ExpectedCommissionType] [bit] NULL,
[ParentPolicyExpectedCommissionId] [int] NULL,
[PercentageFund] [decimal] (18, 0) NULL,
[Notes] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ChangedByUser] [int] NULL,
[PreDiscountAmount] [money] NULL,
[DiscountReasonId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[PolicyExpectedCommissionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyExp_StampDateTime_1__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
PlanMigrationRef varchar(255) null,
CommissionMigrationRef varchar(255) null,
[ChargingType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ExpectedPercentage] [decimal] (18, 2) NULL,
[DueDate] [datetime] NULL,
[EndsOn] [date] NULL
)
GO
ALTER TABLE [dbo].[TPolicyExpectedCommissionAudit] ADD CONSTRAINT [PK_TPolicyExpectedCommissionAudit_2__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPolicyExpectedCommissionAudit_PolicyExpectedCommissionId_ConcurrencyId] ON [dbo].[TPolicyExpectedCommissionAudit] ([PolicyExpectedCommissionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TPolicyExpectedCommissionAudit_StampDateTime_PolicyExpectedCommissionId] ON [dbo].[TPolicyExpectedCommissionAudit] ([StampDateTime], [PolicyExpectedCommissionId])
GO

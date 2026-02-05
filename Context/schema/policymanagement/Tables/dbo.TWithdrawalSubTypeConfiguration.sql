CREATE TABLE [dbo].[TWithdrawalSubTypeConfiguration]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[PlanType] [varchar] (100),
[Type] [varchar] (100),
[ArrangementType] [varchar] (100) null,
[WithdrawalSubType] [varchar] (100),
[IsTaxable] [bit],
[IsTaxFree] [bit],
[IsCrystallizedAmount] [bit]
)
GO

ALTER TABLE [dbo].[TWithdrawalSubTypeConfiguration]
ADD CONSTRAINT PK_TWithdrawalSubTypeConfiguration PRIMARY KEY CLUSTERED (Id);
GO

CREATE NONCLUSTERED INDEX IX_TWithdrawalSubTypeConfiguration_Filter
ON [dbo].[TWithdrawalSubTypeConfiguration] (PlanType, Type, ArrangementType, WithdrawalSubType);
GO

CREATE NONCLUSTERED INDEX IX_TWithdrawalSubTypeConfiguration_Covering
ON [dbo].[TWithdrawalSubTypeConfiguration] (PlanType, Type, ArrangementType, WithdrawalSubType)
INCLUDE (IsTaxable, IsTaxFree);
GO

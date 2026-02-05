CREATE TABLE [dbo].[TRefWithdrawalBasisType]
(
[RefWithdrawalBasisTypeId] [int] NOT NULL IDENTITY(1, 1),
[WithdrawalBasisName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [bit] NOT NULL CONSTRAINT [DF_TRefWithdrawalBasisType_RetireFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefWithdrawalBasisType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefWithdrawalBasisType] ADD CONSTRAINT [PK_TRefWithdrawalBasisType] PRIMARY KEY NONCLUSTERED  ([RefWithdrawalBasisTypeId]) WITH (FILLFACTOR=80)
GO

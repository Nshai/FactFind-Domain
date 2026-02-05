CREATE TABLE [dbo].[TRefWithdrawalType]
(
[RefWithdrawalTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[WithdrawalName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefWithdr_ConcurrencyId_1__56] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefWithdrawalType] ADD CONSTRAINT [PK_TRefWithdrawalType_2__56] PRIMARY KEY NONCLUSTERED  ([RefWithdrawalTypeId]) WITH (FILLFACTOR=80)
GO

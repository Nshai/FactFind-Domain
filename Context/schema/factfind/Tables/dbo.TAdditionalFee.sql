CREATE TABLE [dbo].[TAdditionalFee]
(
[AdditionalFeeId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NULL,
[FeeType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PayableType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FeeAmount] [money] NULL,
[PayableTo] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefundableType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefundableAmount] [money] NULL,
[CRMContactId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdditionalFee_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TAdditionalFee] ADD CONSTRAINT [PK_TAdditionalFee] PRIMARY KEY NONCLUSTERED  ([AdditionalFeeId])
GO

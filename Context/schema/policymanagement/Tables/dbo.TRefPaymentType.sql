CREATE TABLE [dbo].[TRefPaymentType]
(
[RefPaymentTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefPaymentTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [bit] NOT NULL CONSTRAINT [DF_TRefPaymentType_RetireFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPaymentType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPaymentType] ADD CONSTRAINT [PK_TRefPaymentType] PRIMARY KEY NONCLUSTERED  ([RefPaymentTypeId]) WITH (FILLFACTOR=80)
GO

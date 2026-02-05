CREATE TABLE [dbo].[TRefPaymentBasisType]
(
[RefPaymentBasisTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PaymentBasisTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrigoRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPaymen_ConcurrencyId_1__63] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPaymentBasisType] ADD CONSTRAINT [PK_TRefPaymentBasisType_2__63] PRIMARY KEY NONCLUSTERED  ([RefPaymentBasisTypeId]) WITH (FILLFACTOR=80)
GO

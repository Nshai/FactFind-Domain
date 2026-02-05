CREATE TABLE [dbo].[TRefMortgageProductType]
(
[RefMortgageProductTypeId] [int] NOT NULL IDENTITY(1, 1),
[MortgageProductType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefMortgageProductType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefMortgageProductType] ADD CONSTRAINT [PK_TRefMortgageProductType] PRIMARY KEY CLUSTERED  ([RefMortgageProductTypeId]) WITH (FILLFACTOR=80)
GO

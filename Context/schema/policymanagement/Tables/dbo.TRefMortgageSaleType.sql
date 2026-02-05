CREATE TABLE [dbo].[TRefMortgageSaleType]
(
[RefMortgageSaleTypeId] [int] NOT NULL IDENTITY(1, 1),
[MortgageSaleType] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefMortgageSaleType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefMortgageSaleType] ADD CONSTRAINT [PK_TRefMortgageSaleType] PRIMARY KEY NONCLUSTERED  ([RefMortgageSaleTypeId]) WITH (FILLFACTOR=80)
GO
CREATE UNIQUE CLUSTERED INDEX [IDX_UNQ_TRefMortgageSaleType_RefMortgageSaleTypeId] ON [dbo].[TRefMortgageSaleType] ([RefMortgageSaleTypeId]) WITH (FILLFACTOR=80)
GO
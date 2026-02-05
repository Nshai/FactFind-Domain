CREATE TABLE [dbo].[TRefMortgageProcurementFeeDueType]
(
[RefMortgageProcurementFeeDueTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefMortgageProcurementFeeDueType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefMortgageProcurementFeeDueType] ADD CONSTRAINT [PK_TRefMortgageProcurementFeeDueType] PRIMARY KEY CLUSTERED  ([RefMortgageProcurementFeeDueTypeId])
GO

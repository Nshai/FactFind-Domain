CREATE TABLE [dbo].[TMortgageProcurementFee]
(
[MortgageProcurementFeeId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[Amount] [money] NOT NULL,
[RefMortgageProcurementFeeDueTypeId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageProcurementFee_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMortgageProcurementFee] ADD CONSTRAINT [PK_MortgageProcurementFee] PRIMARY KEY CLUSTERED  ([MortgageProcurementFeeId])
GO
ALTER TABLE [dbo].[TMortgageProcurementFee] ADD CONSTRAINT [FK_TMortgageProcurementFee_TPolicyBusiness] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TMortgageProcurementFee] ADD CONSTRAINT [FK_TMortgageProcurementFee_TRefMortgageProcurementFeeDueType] FOREIGN KEY ([RefMortgageProcurementFeeDueTypeId]) REFERENCES [dbo].[TRefMortgageProcurementFeeDueType] ([RefMortgageProcurementFeeDueTypeId])
GO

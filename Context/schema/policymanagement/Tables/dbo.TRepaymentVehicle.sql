CREATE TABLE [dbo].[TRepaymentVehicle]
(
[RepaymentVehicleId] [int] NOT NULL IDENTITY(1, 1),
[MortgageId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRepaymentVehicle_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRepaymentVehicle] ADD CONSTRAINT [PK_TRepaymentVehicle] PRIMARY KEY CLUSTERED  ([RepaymentVehicleId])
GO
ALTER TABLE [dbo].[TRepaymentVehicle] WITH CHECK ADD CONSTRAINT [FK_TRepaymentVehicle_MortgageId_MortgageId] FOREIGN KEY ([MortgageId]) REFERENCES [dbo].[TMortgage] ([MortgageId])
GO
ALTER TABLE [dbo].[TRepaymentVehicle] WITH CHECK ADD CONSTRAINT [FK_TRepaymentVehicle_TPolicyBusiness] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX [IX_TRepaymentVehicle_PolicyBusinessId] ON [dbo].[TRepaymentVehicle] ([PolicyBusinessId]) INCLUDE([MortgageId])
GO

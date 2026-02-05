CREATE TABLE [dbo].[TSwitch]
(
[SwitchId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[RefPlanTypeId] [int] NOT NULL,
[Value] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSwitch_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSwitch] ADD CONSTRAINT [PK_TSwitch] PRIMARY KEY NONCLUSTERED  ([SwitchId])
GO
CREATE NONCLUSTERED INDEX [IDX_TSwitch_PolicyBusinessId] ON [dbo].[TSwitch] ([PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX [IDX_TSwitch_RefPlanTypeId] ON [dbo].[TSwitch] ([RefPlanTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TSwitch_RefProdProviderId] ON [dbo].[TSwitch] ([RefProdProviderId])
GO
ALTER TABLE [dbo].[TSwitch] WITH CHECK ADD CONSTRAINT [FK_TSwitch_PolicyBusinessId_PolicyBusinessId] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TSwitch] ADD CONSTRAINT [FK_TSwitch_RefPlanTypeId_RefPlanTypeId] FOREIGN KEY ([RefPlanTypeId]) REFERENCES [dbo].[TRefPlanType] ([RefPlanTypeId])
GO
ALTER TABLE [dbo].[TSwitch] ADD CONSTRAINT [FK_TSwitch_RefProdProviderId_RefProdProviderId] FOREIGN KEY ([RefProdProviderId]) REFERENCES [dbo].[TRefProdProvider] ([RefProdProviderId])
GO

CREATE TABLE [dbo].[TFundPanelRestricted]
(
[FundPanelRestrictedId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFundPanelRestricted_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFundPanelRestricted] ADD CONSTRAINT [PK_TFundPanelRestricted] PRIMARY KEY CLUSTERED  ([FundPanelRestrictedId])
GO

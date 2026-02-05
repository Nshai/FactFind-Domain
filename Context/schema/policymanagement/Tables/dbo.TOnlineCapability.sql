CREATE TABLE [dbo].[TOnlineCapability]
(
[OnlineCapabilityId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanType2ProdSubTypeId] [int] NULL,
[RefProdProviderId] [int] NULL,
[OnlineProductId] [int] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO

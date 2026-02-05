CREATE TABLE [dbo].[TGroupTradingStyle]
(
[GroupTradingStyleId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGroupTradingStyle_ConcurrencyId] DEFAULT ((1)),
[GroupId] [int] NOT NULL,
[IntegratedSystemId] [int] NOT NULL,
[TradingStyleId] [int] NULL,
[IsPropagate] [bit] NOT NULL CONSTRAINT [DF_TGroupTradingStyle_IsPropagate] DEFAULT ((0)),
[TenantId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TGroupTradingStyle] ADD CONSTRAINT [PK_TGroupTradingStyle] PRIMARY KEY CLUSTERED  ([GroupTradingStyleId])
GO

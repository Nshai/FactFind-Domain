CREATE TABLE [dbo].[TGroupRiskProfileModel]
(
[ModelId] [int] NOT NULL,
[RiskProfileId] [int] NOT NULL,
[GroupId] [int] NOT NULL
)
GO

ALTER TABLE [dbo].[TGroupRiskProfileModel] ADD CONSTRAINT [PK_TGroupRiskProfileModel_ModelId_RiskProfileId_GroupId] PRIMARY KEY CLUSTERED ([ModelId],[RiskProfileId],[GroupId])
GO

CREATE NONCLUSTERED INDEX [IDX_TGroupRiskProfileModel] ON [dbo].[TGroupRiskProfileModel] ([RiskProfileId])
GO

ALTER TABLE [dbo].[TGroupRiskProfileModel] ADD CONSTRAINT [FK_TGroupRiskProfileModel_ModelId_ModelId] FOREIGN KEY ([ModelId]) REFERENCES [dbo].[TPortfolio] ([PortfolioId])
GO

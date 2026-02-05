CREATE TABLE [dbo].[TRiskAttitude]
(
[RiskAttitudeId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[RiskCategoryId] [int] NOT NULL,
[LowerBound] [int] NULL,
[UpperBound] [int] NULL,
[RiskRangeId] [int] NULL,
[Notes] [varchar] (8000)  NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRiskAttitude_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRiskAttitude] ADD CONSTRAINT [PK_TRiskAttitude] PRIMARY KEY NONCLUSTERED  ([RiskAttitudeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRiskAttitude_CRMContactId] ON [dbo].[TRiskAttitude] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRiskAttitude_RiskCategoryId] ON [dbo].[TRiskAttitude] ([RiskCategoryId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRiskAttitude_RiskRangeId] ON [dbo].[TRiskAttitude] ([RiskRangeId])
GO
ALTER TABLE [dbo].[TRiskAttitude] WITH CHECK ADD CONSTRAINT [FK_TRiskAttitude_CRMContactId_CRMContactId] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TRiskAttitude] ADD CONSTRAINT [FK_TRiskAttitude_RiskCategoryId_RiskCategoryId] FOREIGN KEY ([RiskCategoryId]) REFERENCES [dbo].[TRiskCategory] ([RiskCategoryId])
GO
ALTER TABLE [dbo].[TRiskAttitude] ADD CONSTRAINT [FK_TRiskAttitude_RiskRangeId_RiskRangeId] FOREIGN KEY ([RiskRangeId]) REFERENCES [dbo].[TRiskRange] ([RiskRangeId])
GO

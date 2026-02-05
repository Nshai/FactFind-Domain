CREATE TABLE [dbo].[TRiskRange]
(
[RiskRangeId] [int] NOT NULL IDENTITY(1, 1),
[RiskCategoryId] [int] NOT NULL,
[LowerBound] [int] NOT NULL,
[UpperBound] [int] NOT NULL,
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRiskRange_ConcurrencyId_1__58] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRiskRange] ADD CONSTRAINT [PK_TRiskRange_2__58] PRIMARY KEY NONCLUSTERED  ([RiskRangeId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRiskRange_RiskCategoryId] ON [dbo].[TRiskRange] ([RiskCategoryId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TRiskRange] ADD CONSTRAINT [FK_TRiskRange_RiskCategoryId_RiskCategoryId] FOREIGN KEY ([RiskCategoryId]) REFERENCES [dbo].[TRiskCategory] ([RiskCategoryId])
GO

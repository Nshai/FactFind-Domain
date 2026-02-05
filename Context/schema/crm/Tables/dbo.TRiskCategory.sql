CREATE TABLE [dbo].[TRiskCategory]
(
[RiskCategoryId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRiskCateg_ConcurrencyId_1__52] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRiskCategory] ADD CONSTRAINT [PK_TRiskCategory_2__52] PRIMARY KEY NONCLUSTERED  ([RiskCategoryId]) WITH (FILLFACTOR=80)
GO

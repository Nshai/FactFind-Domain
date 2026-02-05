CREATE TABLE [dbo].[TRefPlanTypeGrouping]
(
[RefPlanTypeGroupingId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanTypeId] [int] NOT NULL,
[IsMortgage] [bit] NOT NULL CONSTRAINT [DF_TRefPlanTypeGrouping_IsMortgage] DEFAULT ((0)),
[IsTerm] [bit] NOT NULL CONSTRAINT [DF_TRefPlanTypeGrouping_IsTerm] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanTypeGrouping_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPlanTypeGrouping] ADD CONSTRAINT [PK_TRefPlanTypeGrouping] PRIMARY KEY NONCLUSTERED  ([RefPlanTypeGroupingId])
GO

CREATE TABLE [dbo].[TRefTotalPlanValuationType]
(
[RefTotalPlanValuationTypeId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[ShortDescription] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TRefTotalPlanValuationType] ADD CONSTRAINT [PK_TRefTotalPlanValuationType] PRIMARY KEY CLUSTERED  ([RefTotalPlanValuationTypeId])
GO
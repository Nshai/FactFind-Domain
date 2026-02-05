CREATE TABLE [dbo].[TValWrapperPlanType]
(
[ValWrapperPlanTypeId] [int] NOT NULL IDENTITY(1, 1),
[ValGatingId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValWrapperPlanType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValWrapperPlanType] ADD CONSTRAINT [PK_TValWrapperPlanType] PRIMARY KEY NONCLUSTERED  ([ValWrapperPlanTypeId])
GO

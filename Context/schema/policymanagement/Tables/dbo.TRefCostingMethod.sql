CREATE TABLE [dbo].[TRefCostingMethod]
(
[RefCostingMethodId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IsPMIRelated] [bit] NOT NULL,
)
GO
ALTER TABLE [dbo].[TRefCostingMethod] ADD CONSTRAINT [PK_TRefCostingMethod] PRIMARY KEY CLUSTERED  ([RefCostingMethodId])
GO
ALTER TABLE [dbo].[TRefCostingMethod] ADD  CONSTRAINT [DF_TRefCostingMethod_IsPMIRelated]  DEFAULT ((0)) FOR [IsPMIRelated]
GO

CREATE TABLE [dbo].[TRefProductType]
(
[RefProductTypeId] [int] NOT NULL IDENTITY(1, 1),
[ProductTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IntellifloCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RefProductGroupId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefProductType_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefProductType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefProductType] ADD CONSTRAINT [PK_TRefProductType] PRIMARY KEY NONCLUSTERED  ([RefProductTypeId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TRefProductType] ON [dbo].[TRefProductType] ([RefProductTypeId]) WITH (FILLFACTOR=80)
GO

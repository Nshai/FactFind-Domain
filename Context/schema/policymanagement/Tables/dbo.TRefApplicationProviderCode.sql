CREATE TABLE [dbo].[TRefApplicationProviderCode]
(
[RefApplicationProviderCodeId] [int] NOT NULL IDENTITY(1, 1),
[RefApplicationId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[CodeName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefApplicationProviderCode_ConcurrencyId] DEFAULT ((1)),
[ProviderUrl] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefProductGroupId] INT NULL
)
GO
ALTER TABLE [dbo].[TRefApplicationProviderCode] ADD CONSTRAINT [PK_TRefApplicationProviderCode] PRIMARY KEY NONCLUSTERED  ([RefApplicationProviderCodeId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TRefApplicationProviderCode] ON [dbo].[TRefApplicationProviderCode] ([RefApplicationProviderCodeId]) WITH (FILLFACTOR=80)
GO

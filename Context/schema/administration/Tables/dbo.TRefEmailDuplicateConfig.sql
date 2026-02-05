CREATE TABLE [dbo].[TRefEmailDuplicateConfig]
(
[RefEmailDuplicateConfigId] [int] NOT NULL IDENTITY(1, 1),
[DuplicateConfigName] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefEmailDuplicateConfig_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefEmailDuplicateConfig] ADD CONSTRAINT [PK_TRefEmailDuplicateConfig] PRIMARY KEY CLUSTERED  ([RefEmailDuplicateConfigId])
GO

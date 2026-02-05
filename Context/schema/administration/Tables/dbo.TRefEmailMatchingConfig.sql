CREATE TABLE [dbo].[TRefEmailMatchingConfig]
(
[RefEmailMatchingConfigId] [int] NOT NULL IDENTITY(1, 1),
[MatchingConfigName] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefEmailMatchingConfig_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefEmailMatchingConfig] ADD CONSTRAINT [PK_TRefEmailMatchingConfig] PRIMARY KEY CLUSTERED  ([RefEmailMatchingConfigId])
GO

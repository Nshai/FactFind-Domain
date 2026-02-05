CREATE TABLE [dbo].[TRefSaveEmailConfig]
(
[RefSaveEmailConfigId] [tinyint] NOT NULL IDENTITY(1, 1),
[SaveEmailConfigName] [varchar] (100) NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefSaveEmailConfig_ConcurrencyId] DEFAULT ((1)),
)
GO
ALTER TABLE [dbo].[TRefSaveEmailConfig] ADD CONSTRAINT [PK_TRefSaveEmailConfig] PRIMARY KEY CLUSTERED  ([RefSaveEmailConfigId])
GO

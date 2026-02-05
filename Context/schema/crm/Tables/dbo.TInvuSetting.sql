CREATE TABLE [dbo].[TInvuSetting]
(
[InvuSettingId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[FilePath] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TInvuSetting_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TInvuSetting] ADD CONSTRAINT [PK_TInvuSetting] PRIMARY KEY NONCLUSTERED  ([InvuSettingId])
GO

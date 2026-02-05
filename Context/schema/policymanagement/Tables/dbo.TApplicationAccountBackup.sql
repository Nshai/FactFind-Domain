CREATE TABLE [dbo].[TApplicationAccountBackup]
(
[ApplicationAccountId] [int] NOT NULL,
[RefApplicationId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[UserName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Password] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TApplicationAccountBackup_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TApplicationAccountBackup] ADD CONSTRAINT [PK_TApplicationAccountBackup] PRIMARY KEY NONCLUSTERED  ([ApplicationAccountId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TApplicationAccountBackup] ON [dbo].[TApplicationAccountBackup] ([ApplicationAccountId]) WITH (FILLFACTOR=80)
GO

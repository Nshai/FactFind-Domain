CREATE TABLE [dbo].[TRefBackgroundServiceStatus]
(
[RefBackgroundServiceStatusId] [int] NOT NULL IDENTITY(1, 1),
[StatusName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefBackgroundServiceStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefBackgroundServiceStatus] ADD CONSTRAINT [PK_TRefBackgroundServiceStatus] PRIMARY KEY NONCLUSTERED  ([RefBackgroundServiceStatusId]) WITH (FILLFACTOR=80)
GO

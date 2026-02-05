CREATE TABLE [dbo].[TRefEnvironment]
(
[RefEnvironmentId] [int] NOT NULL IDENTITY(1, 1),
[URL] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefEnvironment_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefEnvironment] ADD CONSTRAINT [PK_TRefEnvironment] PRIMARY KEY NONCLUSTERED  ([RefEnvironmentId]) WITH (FILLFACTOR=80)
GO

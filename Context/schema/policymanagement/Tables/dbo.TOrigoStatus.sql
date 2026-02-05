CREATE TABLE [dbo].[TOrigoStatus]
(
[OrigoStatusId] [int] NOT NULL IDENTITY(1, 1),
[OrigoRef] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[RetiredFg] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOrigoStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TOrigoStatus] ADD CONSTRAINT [PK_TOrigoStatus] PRIMARY KEY NONCLUSTERED  ([OrigoStatusId]) WITH (FILLFACTOR=80)
GO

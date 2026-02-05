CREATE TABLE [dbo].[TRefTaskStatus]
(
[RefTaskStatusId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [varchar] (255) NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefTaskStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefTaskStatus] ADD CONSTRAINT [PK_TRefTaskStatus] PRIMARY KEY CLUSTERED  ([RefTaskStatusId])
GO
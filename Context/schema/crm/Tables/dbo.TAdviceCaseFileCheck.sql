CREATE TABLE [dbo].[TAdviceCaseFileCheck]
(
[AdviceCaseFileCheckId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[AdviceCaseId] [int] NOT NULL,
[FileCheckMiniId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseFileCheck_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviceCaseFileCheck] ADD CONSTRAINT [PK_TAdviceCaseFileCheck] PRIMARY KEY NONCLUSTERED  ([AdviceCaseFileCheckId])
GO

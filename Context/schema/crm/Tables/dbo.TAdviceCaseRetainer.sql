CREATE TABLE [dbo].[TAdviceCaseRetainer]
(
[AdviceCaseRetainerId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[AdviceCaseId] [int] NOT NULL,
[RetainerId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseRetainer_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviceCaseRetainer] ADD CONSTRAINT [PK_TAdviceCaseRetainer] PRIMARY KEY NONCLUSTERED  ([AdviceCaseRetainerId])
GO

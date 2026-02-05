CREATE TABLE [dbo].[TAdviceCaseStatus]
(
[AdviceCaseStatusId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseStatus_TenantId] DEFAULT ((1)),
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsDefault] [bit] NOT NULL CONSTRAINT [DF_TAdviceCaseStatus_IsDefault] DEFAULT ((0)),
[IsComplete] [bit] NOT NULL CONSTRAINT [DF_TAdviceCaseStatus_IsComplete] DEFAULT ((0)),
[IsAutoClose] [bit] NOT NULL CONSTRAINT [DF_TAdviceCaseStatus_IsAutoClose] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviceCaseStatus] ADD CONSTRAINT [PK_TAdviceCaseStatus] PRIMARY KEY NONCLUSTERED  ([AdviceCaseStatusId])
GO

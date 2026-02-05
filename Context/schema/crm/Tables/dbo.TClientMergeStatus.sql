CREATE TABLE [dbo].[TClientMergeStatus]
(
[ClientMergeStatusId] [int] NOT NULL IDENTITY(1, 1),
[ChildCRMContactId] [int] NOT NULL,
[IsMergeComplete] [bit] NOT NULL,
[ErrorMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ClientMergeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TClientMergeStatus_StampDateTime] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[TClientMergeStatus] ADD CONSTRAINT [PK_TClientMergeStatus] PRIMARY KEY CLUSTERED  ([ClientMergeStatusId])
GO

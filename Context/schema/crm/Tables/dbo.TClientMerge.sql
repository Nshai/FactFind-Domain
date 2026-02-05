CREATE TABLE [dbo].[TClientMerge]
(
[ClientMergeId] [int] NOT NULL IDENTITY(1, 1),
[MasterCRMContactId] [int] NOT NULL,
[ChildCRMContactId] [int] NOT NULL,
[MergeFeesRetainers] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[MergePlans] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[DeleteClient] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[MergeClientSharing] [varchar] (3) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_TClientMerge_MergeClientSharing] DEFAULT ('No'),
[MergeTasks] [bit] NULL,
[MergeDocuments] [bit] NULL
)
GO
ALTER TABLE [dbo].[TClientMerge] ADD CONSTRAINT [PK_TClientMerge] PRIMARY KEY CLUSTERED  ([ClientMergeId])
GO

CREATE TABLE [dbo].[TRefCoverTo]
(
[RefCoverToID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefCoverTo] ADD CONSTRAINT [PK_TRefCoverTo] PRIMARY KEY CLUSTERED  ([RefCoverToID])
GO

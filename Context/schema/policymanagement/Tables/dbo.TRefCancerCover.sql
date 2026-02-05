CREATE TABLE [dbo].[TRefCancerCover]
(
[RefCancerCoverId] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (500) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TRefCancerCover] ADD CONSTRAINT [PK_TRefCancerCover] PRIMARY KEY CLUSTERED  ([RefCancerCoverId])
GO

CREATE TABLE [dbo].[TRefFeeModelStatus]
(
[RefFeeModelStatusId] [int] NOT NULL IDENTITY(1, 1),
[Status] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TRefFeeModelStatus] ADD CONSTRAINT [PK_TRefFeeModelStatus] PRIMARY KEY CLUSTERED  ([RefFeeModelStatusId])
GO

CREATE TABLE [dbo].[TRefFeeAdviseType]
(
[RefFeeAdviseTypeId] [int] NOT NULL IDENTITY(1, 1),
[RefFeeAdviseTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TRefFeeAdviseType] ADD CONSTRAINT [PK_TRefFeeAdviseType] PRIMARY KEY CLUSTERED  ([RefFeeAdviseTypeId])
GO

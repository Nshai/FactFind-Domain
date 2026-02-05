CREATE TABLE [dbo].[TRefCoverAmountType]
(
[RefCoverAmountTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefCoverAmountType] ADD CONSTRAINT [PK_TRefCoverAmountType] PRIMARY KEY CLUSTERED  ([RefCoverAmountTypeId])
GO

CREATE TABLE [dbo].[TRefTransferType]
(
[RefTransferTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[TRefTransferType] ADD CONSTRAINT [PK_TRefTransferType] PRIMARY KEY CLUSTERED  ([RefTransferTypeId])
GO
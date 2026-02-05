CREATE TABLE [dbo].[TRefWithdrawalSubType]
(
[RefWithdrawalSubTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[TRefWithdrawalSubType] ADD CONSTRAINT [PK_TRefWithdrawalSubType] PRIMARY KEY CLUSTERED  ([RefWithdrawalSubTypeId])
GO
 
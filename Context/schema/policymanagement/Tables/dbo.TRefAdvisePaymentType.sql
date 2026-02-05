CREATE TABLE [dbo].[TRefAdvisePaymentType]
(
[RefAdvisePaymentTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TRefAdvisePaymentType] ADD CONSTRAINT [PK_TRefAdvisePaymentType] PRIMARY KEY CLUSTERED  ([RefAdvisePaymentTypeId])
GO

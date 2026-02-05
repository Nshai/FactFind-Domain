CREATE TABLE [dbo].[TRefGroupSchemePaymentType]
(
[RefGroupSchemePaymentTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefGroupSchemePaymentType] ADD CONSTRAINT [PK_TRefGroupSchemePaymentType] PRIMARY KEY CLUSTERED  ([RefGroupSchemePaymentTypeId])
GO

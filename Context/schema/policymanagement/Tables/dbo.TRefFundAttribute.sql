CREATE TABLE [dbo].[TRefFundAttribute]
(
[RefFundAttributeId] [int] NOT NULL IDENTITY(1, 1),
[AttributeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AttributeCode] [varchar] (25) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefFundAttribute_ConcurrencyId] DEFAULT ((1)),
[AttributeBit] [int] NULL
)
GO
ALTER TABLE [dbo].[TRefFundAttribute] ADD CONSTRAINT [PK_TRefFundAttribute] PRIMARY KEY CLUSTERED  ([RefFundAttributeId])
GO

CREATE TABLE [dbo].[TRefInsuredItemType]
(
[RefInsuredItemTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefInsuredItemType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefInsuredItemType] ADD CONSTRAINT [PK_TRefInsuredItemType] PRIMARY KEY CLUSTERED  ([RefInsuredItemTypeId])
GO

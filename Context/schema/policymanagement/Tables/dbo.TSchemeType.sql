CREATE TABLE [dbo].[TSchemeType]
(
[SchemeTypeId] [int] NOT NULL IDENTITY(1, 1),
[SchemeTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsRetired] [bit] NOT NULL CONSTRAINT [DF_TSchemeType_IsRetired] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSchemeType_ConcurrencyId] DEFAULT ((1)),
[RefLicenceTypeId] [int] NOT NULL CONSTRAINT [DF__TSchemeTy__RefLi__6BB09115] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSchemeType] ADD CONSTRAINT [PK_TSchemeType] PRIMARY KEY NONCLUSTERED  ([SchemeTypeId])
GO

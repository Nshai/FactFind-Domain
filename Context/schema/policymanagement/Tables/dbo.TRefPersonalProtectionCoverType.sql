CREATE TABLE [dbo].[TRefPersonalProtectionCoverType]
(
[RefPersonalProtectionCoverTypeId] [int] NOT NULL IDENTITY(1, 1),
[CoverTypeName] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_RefPersonalProtectionCoverType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPersonalProtectionCoverType] ADD CONSTRAINT [PK_RefPersonalProtectionCoverType] PRIMARY KEY CLUSTERED  ([RefPersonalProtectionCoverTypeId])
GO

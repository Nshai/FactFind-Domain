CREATE TABLE [dbo].[TRefTotalPermanentDisabilityType]
(
[RefTotalPermanentDisabilityTypeId] [int] NOT NULL IDENTITY(1, 1),
[TypeName] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_RefTotalPermanentDisabilityType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefTotalPermanentDisabilityType] ADD CONSTRAINT [PK_RefTotalPermanentDisabilityType] PRIMARY KEY CLUSTERED  ([RefTotalPermanentDisabilityTypeId])
GO

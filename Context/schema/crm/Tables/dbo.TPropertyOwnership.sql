CREATE TABLE [dbo].[TPropertyOwnership]
(
[PropertyOwnershipId] [int] NOT NULL IDENTITY(1, 1),
[OwnershipType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPropertyOwnership_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPropertyOwnership] ADD CONSTRAINT [PK_TPropertyOwnership] PRIMARY KEY NONCLUSTERED  ([PropertyOwnershipId]) WITH (FILLFACTOR=80)
GO

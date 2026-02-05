CREATE TABLE [dbo].[TRepossessedExt]
(
[RepossessedExtId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[PropertyRepossessedFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRepossessedExt_ConcurrencyId] DEFAULT ((1))
)
GO

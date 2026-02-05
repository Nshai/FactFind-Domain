CREATE TABLE [dbo].[TFeeExtended]
(
[FeeExtendedId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NOT NULL,
[MigrationReference] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeeExtended_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFeeExtended] ADD CONSTRAINT [PK_TFeeExtended] PRIMARY KEY CLUSTERED  ([FeeExtendedId])
GO

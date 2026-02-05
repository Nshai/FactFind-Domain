CREATE TABLE [dbo].[TToleranceLevel]
(
[ToleranceLevelId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Tolerance] [money] NOT NULL,
[PurchaseTolerance] [money] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TToleranceLevel_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TToleranceLevel] ADD CONSTRAINT [PK_TToleranceLevel] PRIMARY KEY CLUSTERED  ([ToleranceLevelId]) WITH (FILLFACTOR=80)
GO

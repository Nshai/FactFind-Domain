CREATE TABLE [dbo].[TMultiTieBackup]
(
[MultiTieId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[PlanTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMultiTieBackup_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMultiTieBackup] ADD CONSTRAINT [PK_TMultiTieBackup] PRIMARY KEY CLUSTERED  ([MultiTieId]) WITH (FILLFACTOR=80)
GO

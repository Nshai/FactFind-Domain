CREATE TABLE [dbo].[TMultiTieConfigToAdviser]
(
[MultiTieConfigToAdviserId] [int] NOT NULL IDENTITY(1, 1),
[MultiTieConfigId] [int] NOT NULL,
[AdviserId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMultiTieConfigToAdviser_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMultiTieConfigToAdviser] ADD CONSTRAINT [PK_TMultiTieConfigToAdviser] PRIMARY KEY CLUSTERED  ([MultiTieConfigToAdviserId]) WITH (FILLFACTOR=80)
GO

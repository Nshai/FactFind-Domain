CREATE TABLE [dbo].[TAgencyNumber]
(
[AgencyNumberId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PractitionerId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[AgencyNumber] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[DateChanged] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAgencyNumber_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAgencyNumber] ADD CONSTRAINT [PK_TAgencyNumber] PRIMARY KEY CLUSTERED  ([AgencyNumberId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_AgencyNumber_RefProdProviderId]
ON [dbo].[TAgencyNumber] ([RefProdProviderId])
INCLUDE ([PractitionerId],[AgencyNumber])
GO

CREATE TABLE [dbo].[TReportAddressConfiguration]
(
[ReportAddressConfigurationId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[ReportName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[UseOrganisationAddress] [bit] NOT NULL CONSTRAINT [DF_TReportAddressConfiguration_UseOrganisationAddress] DEFAULT ((0)),
[UseLegalEntityAddress] [bit] NOT NULL CONSTRAINT [DF_TReportAddressConfiguration_UseLegalEntityAddress] DEFAULT ((0)),
[UseGroupAddress] [bit] NOT NULL CONSTRAINT [DF_TReportAddressConfiguration_UseGroupAddress] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TReportAddressConfiguration_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TReportAddressConfiguration] ADD CONSTRAINT [PK_TReportAddressConfiguration] PRIMARY KEY NONCLUSTERED  ([ReportAddressConfigurationId]) WITH (FILLFACTOR=80)
GO

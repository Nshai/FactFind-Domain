CREATE TABLE [dbo].[TReportAddressConfigurationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[ReportName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[UseOrganisationAddress] [bit] NOT NULL CONSTRAINT [DF_TReportAddressConfigurationAudit_UseOrganisationAddress] DEFAULT ((0)),
[UseLegalEntityAddress] [bit] NOT NULL CONSTRAINT [DF_TReportAddressConfigurationAudit_UseLegalEntityAddress] DEFAULT ((0)),
[UseGroupAddress] [bit] NOT NULL CONSTRAINT [DF_TReportAddressConfigurationAudit_UseGroupAddress] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TReportAddressConfigurationAudit_ConcurrencyId] DEFAULT ((1)),
[ReportAddressConfigurationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TReportAddressConfigurationAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TReportAddressConfigurationAudit] ADD CONSTRAINT [PK_TReportAddressConfigurationAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TReportAddressConfigurationAudit_ReportAddressConfigurationId_ConcurrencyId] ON [dbo].[TReportAddressConfigurationAudit] ([ReportAddressConfigurationId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

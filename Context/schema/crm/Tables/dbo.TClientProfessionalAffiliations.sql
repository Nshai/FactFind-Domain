CREATE TABLE [dbo].[TClientProfessionalAffiliations]
(
[ClientProfessionalAffiliationsId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[TenantAdvisoryFirm] [varchar] (4000) NULL,
[OtherAdvisoryFirm] [varchar] (4000) NULL,
[OtherFinancialInstitution] [varchar] (4000) NULL,
[SeniorPosition] [varchar] (4000) NULL,
[SeniorPoliticalFigure] [varchar] (4000) NULL,
[OtherBrokerageAccount] [varchar] (255) NULL
)
GO

ALTER TABLE [dbo].[TClientProfessionalAffiliations] ADD CONSTRAINT [PK_TClientProfessionalAffiliations] PRIMARY KEY CLUSTERED  ([ClientProfessionalAffiliationsId])
GO
CREATE NONCLUSTERED INDEX [IDX_TClientProfessionalAffiliations_CRMContactId] ON [dbo].[TClientProfessionalAffiliations] ([CRMContactId])
GO
ALTER TABLE [dbo].[TClientProfessionalAffiliations] ADD CONSTRAINT [FK_TClientProfessionalAffiliations_TCRMContact] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
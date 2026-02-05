CREATE TABLE [dbo].[TClientProfessionalAffiliationsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ClientProfessionalAffiliationsId] [int] NULL,
[CRMContactId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[TenantAdvisoryFirm] [varchar] (4000)NULL,
[OtherAdvisoryFirm] [varchar] (4000)NULL,
[OtherFinancialInstitution] [varchar] (4000)NULL,
[SeniorPosition] [varchar] (4000)NULL,
[SeniorPoliticalFigure] [varchar] (4000)NULL,
[OtherBrokerageAccount] [varchar] (255)NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TClientProfessionalAffiliationsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255)NULL
)
GO
ALTER TABLE [dbo].[TClientProfessionalAffiliationsAudit] ADD CONSTRAINT [PK_TClientProfessionalAffiliationsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

CREATE TABLE [dbo].[TPlanDescriptionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[SchemeOwnerCRMContactId] [int] NULL,
[SchemeStatus] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SchemeNumber] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SchemeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SchemeStatusDate] [datetime] NULL,
[SchemeSellingAdvisorPractitionerId] [datetime] NULL,
[MaturityDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPlanDescriptionAudit_ConcurrencyId] DEFAULT ((1)),
[PlanDescriptionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPlanDescriptionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PlanMigrationRef] varchar(255)
)
GO
ALTER TABLE [dbo].[TPlanDescriptionAudit] ADD CONSTRAINT [PK_TPlanDescriptionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPlanDescriptionAudit_PlanDescriptionId_ConcurrencyId] ON [dbo].[TPlanDescriptionAudit] ([PlanDescriptionId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IX_TPlanDescriptionAudit_StampDateTime_PlanDescriptionId] ON [dbo].[TPlanDescriptionAudit] ([StampDateTime], [PlanDescriptionId]) WITH (FILLFACTOR=90)
GO

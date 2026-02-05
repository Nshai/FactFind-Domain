CREATE TABLE [dbo].[TPolicyBeneficaryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[BeneficaryCRMContactId] [int] NULL,
[BeneficiaryPersonalContactId] [int] NULL,
[BeneficaryPercentage] [decimal] (5, 2) NULL,
[PolicyDetailId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBen_ConcurrencyId_1__56] DEFAULT ((1)),
[PolicyBeneficaryId] [int] NOT NULL,
[RelationshipType] [nvarchar] (50) NULL,
[IsPerStirpes] [bit] NULL,
[Type] [nvarchar] (50) NULL,
[CrmContactId] [int] NULL,
[SubjectType][int] NULL,
[Amount] [decimal] (16, 2) NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyBen_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MigrationRef] [nvarchar] (255) NULL,
[ExternalReference] [VARCHAR](60) NULL,
[OwnerClientId] [int] NULL,
[BindingLapsingDate] [date] NULL
)
GO
ALTER TABLE [dbo].[TPolicyBeneficaryAudit] ADD CONSTRAINT [PK_TPolicyBeneficaryAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPolicyBeneficaryAudit_PolicyBeneficaryId_ConcurrencyId] ON [dbo].[TPolicyBeneficaryAudit] ([PolicyBeneficaryId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

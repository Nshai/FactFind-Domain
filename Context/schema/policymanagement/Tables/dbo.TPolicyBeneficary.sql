CREATE TABLE [dbo].[TPolicyBeneficary]
(
[PolicyBeneficaryId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[BeneficaryCRMContactId] [int] NULL,
[BeneficiaryPersonalContactId] [int] NULL,
[BeneficaryPercentage] [decimal] (5, 2) NULL,
[PolicyDetailId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBeneficary_ConcurrencyId] DEFAULT ((1)),
[BeneficaryName] [nvarchar] (100) NULL,
[DateOfBirth] [date] NULL,
[BeneficiaryType] [int] NOT NULL CONSTRAINT [DF__TPolicyBe__Benef__10DACC56] DEFAULT ((1)),
[LastUpdatedAt] [datetime] NOT NULL CONSTRAINT [DF_TPolicyBeneficary_LastUpdatedAt] DEFAULT ((GETDATE())),
[RelationshipTypeId] [int] NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF__TPolicyBe__IsArc__51F722FB] DEFAULT ((0)),
[RelationshipType] [nvarchar] (50) NULL,
[IsPerStirpes] [bit] NULL,
[Type] [nvarchar] (50) NULL,
[CrmContactId] [int] NULL,
[SubjectType][int] NOT NULL,
[Amount] [decimal] (16, 2) NULL,
[MigrationRef] [nvarchar] (255) NULL,
[ExternalReference] [VARCHAR](60) NULL,
[OwnerClientId] [int] NULL,
[BindingLapsingDate] [date] NULL
)
GO
ALTER TABLE [dbo].[TPolicyBeneficary] ADD CONSTRAINT [PK_TPolicyBeneficary] PRIMARY KEY CLUSTERED  ([PolicyBeneficaryId]) WITH (DATA_COMPRESSION = PAGE, FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX IDX_TPolicyBeneficiary_BeneficaryCRMContactId ON dbo.TPolicyBeneficary(BeneficaryCRMContactId) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBeneficary_PolicyDetailId] ON [dbo].[TPolicyBeneficary] ([PolicyDetailId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TPolicyBeneficary] ADD CONSTRAINT [FK_TPolicyBeneficary_PolicyDetailId_PolicyDetailId] FOREIGN KEY ([PolicyDetailId]) REFERENCES [dbo].[TPolicyDetail] ([PolicyDetailId])
GO

ALTER TABLE [dbo].[TPolicyBeneficary] DROP CONSTRAINT [PK_TPolicyBeneficary]
GO


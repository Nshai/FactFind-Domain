CREATE TABLE [dbo].[TPolicyBusinessToProfessionalContact]
(
[PolicyBusinessToProfessionalContactId] [int] NOT NULL IDENTITY(1, 1),
[ProfessionalContactId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBusinessToProfessionalContact_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPolicyBusinessToProfessionalContact] ADD CONSTRAINT [PK_TPolicyBusinessToProfessionalContact] PRIMARY KEY CLUSTERED  ([PolicyBusinessToProfessionalContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusinessToProfessionalContact_PolicyBusinessId]  ON [dbo].[TPolicyBusinessToProfessionalContact] (PolicyBusinessId)    
GO

CREATE TABLE [dbo].[TPolicyBusinessToProfessionalContactAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessToProfessionalContactId] [int] NOT NULL,
[ProfessionalContactId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBusinessToProfessionalContactAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyBusinessToProfessionalContactAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPolicyBusinessToProfessionalContactAudit] ADD CONSTRAINT [PK_TPolicyBusinessToProfessionalContactAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

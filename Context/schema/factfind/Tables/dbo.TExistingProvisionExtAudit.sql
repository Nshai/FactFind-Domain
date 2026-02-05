CREATE TABLE [dbo].[TExistingProvisionExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[existingMortgFg] [bit] NULL,
[numExistingMortgages] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TExistingProvisionExtAudit_ConcurrencyId] DEFAULT ((1)),
[ExistingProvisionExtId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TExistingProvisionExtAudit] ADD CONSTRAINT [PK_TExistingProvisionExtAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO

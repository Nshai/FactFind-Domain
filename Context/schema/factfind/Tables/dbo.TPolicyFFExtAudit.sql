CREATE TABLE [dbo].[TPolicyFFExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ExistingProtection] [bit] NULL,
[NonDisclosure] [bit] NULL,
[GoalsAndNeeds] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NextSteps] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ExistingDeathInServiceBenefits] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[PolicyFFExtId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPolicyFFExtAudit] ADD CONSTRAINT [PK_TPolicyFFExtAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

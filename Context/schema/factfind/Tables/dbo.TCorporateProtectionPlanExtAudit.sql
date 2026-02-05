CREATE TABLE [dbo].[TCorporateProtectionPlanExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[PolicyBusinessId] [int] NULL,
[AssignedInTrustDetails] [varchar] (2304) COLLATE Latin1_General_CI_AS NULL,
[IntendToCancel] [bit] NULL,
[CorporateProtectionPlanExtId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCorporateProtectionPlanExtAudit_ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCorporateProtectionPlanExtAudit] ADD CONSTRAINT [PK_TCorporateProtectionPlanExtAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

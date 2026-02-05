CREATE TABLE [dbo].[TContributionsDetailsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EmployerPercentage] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[EmployeePercentage] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[EmployerFixedCost] [money] NULL,
[EmployeeFixedCost] [money] NULL,
[CRMContactId] [int] NOT NULL,
[ContributionsDetailsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TContribu__Concu__4F1DA8B1] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TContributionsDetailsAudit] ADD CONSTRAINT [PK_TContributionsDetailsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

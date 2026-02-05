CREATE TABLE [dbo].[TRefAdviceContributionTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefAdviceContributionTypeId] [int] NOT NULL,
[ContributionType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefAdviceContributionTypeAudit] ADD CONSTRAINT [PK_TRefAdviceContributionTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO

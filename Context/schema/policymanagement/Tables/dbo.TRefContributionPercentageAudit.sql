CREATE TABLE [dbo].[TRefContributionPercentageAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Descriptor] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFG] [bit] NOT NULL,
[DPMapping] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefContributionPercentageId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefContributionPercentageAudit] ADD CONSTRAINT [PK_TRefContributionPercentageAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

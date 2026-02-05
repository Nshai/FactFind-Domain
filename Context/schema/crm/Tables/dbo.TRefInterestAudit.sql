CREATE TABLE [dbo].[TRefInterestAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Descriptor] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Interest] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OpportunityTypeId] [int] NULL,
[OpportunityCreationFg] [bit] NOT NULL CONSTRAINT [DF_TRefInterestAudit_OpportunityCreationFg] DEFAULT ((0)),
[Probability] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_TRefInterestAudit_Probability] DEFAULT ((0)),
[LeadVersionFG] [bit] NOT NULL CONSTRAINT [DF_TRefInterestAudit_LeadVersionFG] DEFAULT ((0)),
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefInterestAudit_ConcurrencyId] DEFAULT ((1)),
[RefInterestId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefInterestAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ArchiveFG] [bit] NOT NULL CONSTRAINT [DF_TRefInterestAudit_ArchiveFG] DEFAULT ((0)),
[Ordinal] [int] NULL,
[SystemFG] [bit] NOT NULL CONSTRAINT [DF_TRefInterestAudit_SystemFG] DEFAULT ((0)),
[DefaultFG] [bit] NULL CONSTRAINT [DF_TRefInterestAudit_DefaultFG] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRefInterestAudit] ADD CONSTRAINT [PK_TRefInterestAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO

CREATE TABLE [dbo].[TRefExpenditureGroupAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ConcurrencyId] [int] NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Ordinal] [tinyint] NULL,
[IsConsolidateEnabled] [bit] NOT NULL,
[RefExpenditureGroupId] [int] NULL,
[TenantId] [int] NULL,
[RegionCode] [nvarchar](2) NULL,
[Attributes] [nvarchar](MAX) NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefExpenditureGroupAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefExpenditureGroupAudit] ADD CONSTRAINT [PK_TRefExpenditureGroupAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO

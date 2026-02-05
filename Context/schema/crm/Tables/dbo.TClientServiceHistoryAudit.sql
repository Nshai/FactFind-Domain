CREATE TABLE [dbo].[TClientServiceHistoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ClientServiceHistoryId] [int] NULL,
[CRMContactId] [int] NULL,
[ChangeType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ServiceStatusIdFrom] [int] NULL,
[ServiceStatusIdTo] [int] NULL,
[FeeModelIdFrom] [int] NULL,
[FeeModelIdTo] [int] NULL,
[AdviserIdFrom] [int] NULL,
[AdviserIdTo] [int] NULL,
[ChangedByUserId] [int] NULL,
[ChangeDate] [datetime] NULL,
[ServiceStatusStartDate] [datetime] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RelationshipFrom] varchar(550) NULL,
[RelationshipTo] varchar(550) NULL,
[FromUserId] [int] NULL,
[ToUserId] [int] NULL,
[VulnerabilityFromId] [int] NULL,
[VulnerabilityToId] [int] NULL,
[ClientSegmentIdFrom] [int] NULL,
[ClientSegmentIdTo] [int] NULL,
[ClientSegmentStartDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TClientServiceHistoryAudit] ADD CONSTRAINT [PK_TClientServiceHistoryAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

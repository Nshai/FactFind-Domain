CREATE TABLE [dbo].[TClientServiceHistory]
(
[ClientServiceHistoryId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ChangeType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ServiceStatusIdFrom] [int] NULL,
[ServiceStatusIdTo] [int] NULL,
[FeeModelIdFrom] [int] NULL,
[FeeModelIdTo] [int] NULL,
[AdviserIdFrom] [int] NULL,
[AdviserIdTo] [int] NULL,
[ChangedByUserId] [int] NOT NULL,
[ChangeDate] [datetime] NOT NULL,
[ServiceStatusStartDate] [datetime] NULL,
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
ALTER TABLE [dbo].[TClientServiceHistory] ADD CONSTRAINT [PK_TClientServiceHistory] PRIMARY KEY CLUSTERED  ([ClientServiceHistoryId])
GO
CREATE NONCLUSTERED INDEX IX_TClientServiceHistory_CRMContactId ON [dbo].[TClientServiceHistory] ([CRMContactId])
GO
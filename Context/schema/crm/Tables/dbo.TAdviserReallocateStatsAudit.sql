CREATE TABLE [dbo].[TAdviserReallocateStatsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AdviserReallocateStatsId] [int] NOT NULL,
[ClientCount] [int] NULL,
[RelatedClientCount] [int] NULL,
[TasksCount] [int] NULL,
[OpportunitiesCount] [int] NULL,
[ServiceCasesCount] [int] NULL,
[NewAdviserPartyId] [int] NULL,
[UserId] [int] NULL,
[TenantId] [int] NULL,
[ReallocateStatus] [int] NULL,
[ReallocateErrorMessage] [varchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[Timestamp] [datetime] NOT NULL CONSTRAINT [DF_TAdviserReallocateStatsAudit_Timestamp] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviserReallocateStatsAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdviserReallocateStatsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdviserReallocateStatsAudit] ADD CONSTRAINT [PK_TAdviserReallocateStatsAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAdviserReallocateStatsAudit_AdviserReallocateStatsId_ConcurrencyId] ON [dbo].[TAdviserReallocateStatsAudit] ([AdviserReallocateStatsId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO

CREATE TABLE [dbo].[TAdviserReallocateStats]
(
[AdviserReallocateStatsId] [int] NOT NULL IDENTITY(1, 1),
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
[Timestamp] [datetime] NOT NULL CONSTRAINT [DF_TAdviserReallocateStats_Timestamp] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviserReallocateStats_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviserReallocateStats] ADD CONSTRAINT [PK_TAdviserReallocateStats] PRIMARY KEY CLUSTERED  ([AdviserReallocateStatsId])
GO

CREATE TABLE [dbo].[TPlanExceptionQueueAudit]
(
[Audit] [int] NOT NULL IDENTITY(1, 1),
[PlanExceptionQueueId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[PlanTypeExceptionId] [int] NOT NULL,
[IsPreSale] [int] NOT NULL,
[TnCCoachId] [int] NULL,
[DateCreated] [datetime] NOT NULL,
[DateModified] [datetime] NOT NULL,
[TenantId] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsArchived] [bit] NOT NULL,
[ArchivedDate] [datetime] NULL,
[ArchiveReason] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPlanExceptionQueueAudit] ADD CONSTRAINT [PK_TPlanExceptionQueueAudit] PRIMARY KEY CLUSTERED  ([Audit])
GO

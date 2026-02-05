CREATE TABLE [dbo].[TPlanExceptionQueue]
(
[PlanExceptionQueueId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[PlanTypeExceptionId] [int] NOT NULL,
[IsPreSale] [bit] NOT NULL,
[TnCCoachId] [int] NULL,
[DateCreated] [datetime] NOT NULL,
[DateModified] [datetime] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TPlanExceptionQueue_IsArchived] DEFAULT ((0)),
[ArchivedDate] [datetime] NULL,
[ArchiveReason] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPlanExceptionQueue] ADD CONSTRAINT [PK_PlanExceptionQueue] PRIMARY KEY CLUSTERED  ([PlanExceptionQueueId])
GO
ALTER TABLE [dbo].[TPlanExceptionQueue] ADD CONSTRAINT [FK_TPlanExceptionQueue_TPlanTypeException] FOREIGN KEY ([PlanTypeExceptionId]) REFERENCES [dbo].[TPlanTypeException] ([PlanTypeExceptionId])
GO
ALTER TABLE [dbo].[TPlanExceptionQueue] ADD CONSTRAINT [FK_TPlanExceptionQueue_TPolicyBusiness] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO

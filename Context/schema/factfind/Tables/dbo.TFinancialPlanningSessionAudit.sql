CREATE TABLE [dbo].[TFinancialPlanningSessionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[FactFindId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_TFinancialPlanningSessionAudit_Description] DEFAULT ('Planning Session'),
[Date] [datetime] NOT NULL CONSTRAINT [DF_TFinancialPlanningSessionAudit_Date] DEFAULT (getdate()),
[RefFinancialPlanningSessionStatusId] [int] NULL CONSTRAINT [DF_TFinancialPlanningSessionAudit_RefFinancialPlanningSessionStatusId] DEFAULT ((1)),
[UserId] [int] NOT NULL,
[OpportunityId] [int] NULL,
[DocumentId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningSessionAudit_ConcurrencyId] DEFAULT ((0)),
[FinancialPlanningSessionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningSessionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[SessionId] [uniqueidentifier] NULL,
[IsCompleted] [bit] NULL,
[CRMContactId2] [int] NULL,
[ServiceCaseId] [int] NULL,
[FeeModelId] [int] NULL,
[InitialFeePercentage] [decimal] (18, 0) NULL,
[OngoingFeePercentage] [decimal] (18, 0) NULL,
[RequestFailed] [bit] NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningSessionAudit] ADD CONSTRAINT [PK_TFinancialPlanningSessionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningSessionAudit_FinancialPlanningSessionId_ConcurrencyId] ON [dbo].[TFinancialPlanningSessionAudit] ([FinancialPlanningSessionId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO

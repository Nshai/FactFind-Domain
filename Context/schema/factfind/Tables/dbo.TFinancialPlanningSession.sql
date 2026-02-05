CREATE TABLE [dbo].[TFinancialPlanningSession]
(
[FinancialPlanningSessionId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[FactFindId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_TFinancialPlanningSession_Description] DEFAULT ('Planning Session'),
[Date] [datetime] NOT NULL CONSTRAINT [DF_TFinancialPlanningSession_Date] DEFAULT (getdate()),
[RefFinancialPlanningSessionStatusId] [int] NULL CONSTRAINT [DF_TFinancialPlanningSession_RefFinancialPlanningSessionStatusId] DEFAULT ((1)),
[UserId] [int] NOT NULL,
[OpportunityId] [int] NULL,
[DocumentId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningSession_ConcurrencyId] DEFAULT ((0)),
[SessionId] [uniqueidentifier] NULL,
[IsCompleted] [bit] NULL,
[CRMContactId2] [int] NULL,
[ServiceCaseId] [int] NULL,
[FeeModelId] [int] NULL,
[InitialFeePercentage] [decimal] (18, 0) NULL,
[OngoingFeePercentage] [decimal] (18, 0) NULL,
[RequestFailed] [bit] NULL CONSTRAINT [DF__TFinancia__Reque__59A6241C] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningSession] ADD CONSTRAINT [PK_TFinancialPlanningSession] PRIMARY KEY CLUSTERED  ([FinancialPlanningSessionId])
GO
CREATE NONCLUSTERED INDEX IDX_TFinancialPlanningSession_ServiceCaseId ON [dbo].[TFinancialPlanningSession] ([ServiceCaseId])
INCLUDE ([FinancialPlanningSessionId],[FinancialPlanningId],[CRMContactId],[CRMContactId2],[Date])
GO
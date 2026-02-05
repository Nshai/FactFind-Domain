CREATE TABLE [dbo].[TDynamicPlannerSagaData]
(
[DynamicPlannerSagaDataId] [uniqueidentifier] NOT NULL,
[Originator] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[OriginalMessageId] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[TimedOutAt] [datetime] NULL,
[FactFindId] [int] NOT NULL,
[FinancialPlanningId] [int] NOT NULL,
[FinancialPlanningSessionId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[LoggedOnUserId] [int] NOT NULL,
[ClientId] [int] NOT NULL,
[SecondaryClientId] [int] NULL,
[StartSendDateTime] [datetime] NULL,
[ResponseFromSendDateTime] [datetime] NULL,
[MessagePosted] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[MessageResponseFromPost] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ClientErrorMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[StartRepopDateTime] [datetime] NULL,
[RepopMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[AdviserUnitId] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NULL,
[OriginatingSystemId] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NULL,
[AdviserId] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NULL,
[OrganisationUnitId] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NULL,
[SessionOpportunityId] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NULL,
[FinancialPlanningScenarioId] [int] NULL,
[PolicyBusinessIds] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[IsDeleted] [bit] NULL
)
GO
ALTER TABLE [dbo].[TDynamicPlannerSagaData] ADD CONSTRAINT [PK_TDynamicPlannerSagaData] PRIMARY KEY CLUSTERED  ([DynamicPlannerSagaDataId])
GO

CREATE TABLE [dbo].[TIntegrationActivity]
(
[IntegrationActivityId] [int] NOT NULL IDENTITY(1, 1),
[ActivityType] [int] NULL,
[Description] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ErrorDetails] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[CreatedOn] [datetime] NULL,
[Success] [bit] NOT NULL CONSTRAINT [DF_TAbstractIntegrationActivity_Success] DEFAULT ((0)),
[IntegratedSystemId] [int] NULL,
[SagaId] [uniqueidentifier] NULL,
[Discriminator] [varchar] (25) COLLATE Latin1_General_CI_AS NULL,
[PlanId] [int] NULL,
[QuoteId] [int] NULL,
[PartyId] [int] NULL,
[UserId] [int] NULL,
[UserName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAbstractIntegrationActivity_ConcurrencyId] DEFAULT ((1)),
[ActivitySubType] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TIntegrationActivity] ADD CONSTRAINT [PK_TIntegrationActivity] PRIMARY KEY CLUSTERED  ([IntegrationActivityId])
GO

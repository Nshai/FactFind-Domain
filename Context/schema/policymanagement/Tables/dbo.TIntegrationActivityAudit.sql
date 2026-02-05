CREATE TABLE [dbo].[TIntegrationActivityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ActivityType] [int] NULL,
[Description] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ErrorDetails] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[CreatedOn] [datetime] NULL,
[Success] [bit] NOT NULL CONSTRAINT [DF_TAbstractIntegrationActivityAudit_Success] DEFAULT ((0)),
[IntegratedSystemId] [int] NULL,
[SagaId] [uniqueidentifier] NULL,
[Discriminator] [varchar] (25) COLLATE Latin1_General_CI_AS NULL,
[PlanId] [int] NULL,
[QuoteId] [int] NULL,
[PartyId] [int] NULL,
[UserId] [int] NULL,
[UserName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAbstractIntegrationActivityAudit_ConcurrencyId] DEFAULT ((1)),
[IntegrationActivityId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAbstractIntegrationActivityAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ActivitySubType] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TIntegrationActivityAudit] ADD CONSTRAINT [PK_TAbstractIntegrationActivityAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

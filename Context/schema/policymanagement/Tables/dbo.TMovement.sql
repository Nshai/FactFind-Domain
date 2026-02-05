CREATE TABLE [dbo].[TMovement]
(
	[MovementId] [int] NOT NULL IDENTITY(1, 1),
	[TenantId] [int] NOT NULL,
	[PractitionerId] [int] NOT NULL,
	[PolicyBusinessId] [int] NULL,
	[FeeId] [int] NULL,
	[LinkedPolicyBusinessId] [int] NULL,
	[IsRecurring] int NOT NULL CONSTRAINT [DF_TMovement_IsRecurring] DEFAULT ((0)) ,
	[PayAdjustId] [int] NULL,
	[IsPayawayReceived] Int,
	[MovementDateTime] datetime NOT NULL,
	[CreatedDateTime] datetime NOT NULL,
	[IncomeTypeName] varchar(200),
	[Percentage] decimal(10,2) NOT NULL CONSTRAINT [DF_TMovement_Percentage] DEFAULT ((0)),
	[GrossAmount] money NOT NULL CONSTRAINT [DF_TMovement_GrossAmount] DEFAULT ((0)), 
	[IntroducerAmount] money NOT NULL CONSTRAINT [DF_TMovement_IntroducerAmount] DEFAULT ((0)), 
	[IntroducerName] varchar(200),
	[ClientAmount] money NOT NULL CONSTRAINT [DF_TMovement_ClientAmount] DEFAULT ((0)), 
	[ClientName] varchar(200),
	[AdviserAmount] money NOT NULL CONSTRAINT [DF_TMovement_AdviserAmount] DEFAULT ((0)), 
	[AdviserName] varchar(200),
	[NetAmount] money NOT NULL CONSTRAINT [DF_TMovement_NetAmount] DEFAULT ((0)),
	[VATAmount] money NOT NULL CONSTRAINT [DF_TMovement_VATAmount] DEFAULT ((0)),
	[LastRunDateTime] datetime NULL
)
GO
ALTER TABLE [dbo].[TMovement] ADD CONSTRAINT [PK_TMovement] PRIMARY KEY NONCLUSTERED  (MovementId) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TMovement_TenantId_PractitionerId_IsRecurring_MovementDateTime]
ON [dbo].[TMovement] ([TenantId],[PractitionerId],[IsRecurring],[MovementDateTime])
INCLUDE ([MovementId],[PolicyBusinessId],[FeeId],[LinkedPolicyBusinessId],[PayAdjustId],[IsPayawayReceived],[CreatedDateTime],[IncomeTypeName],[Percentage],[GrossAmount],[IntroducerAmount],[IntroducerName],[ClientAmount],[ClientName],[AdviserAmount],[AdviserName],[NetAmount],[VATAmount])
GO
CREATE NONCLUSTERED INDEX [IDX_TMovement_TenantId_PolicyBusinessId]
ON [dbo].[TMovement] ([TenantId],[PolicyBusinessId])
INCLUDE ([PractitionerId],[IncomeTypeName],[Percentage])
GO
CREATE NONCLUSTERED INDEX [IDX_TMovement_TenantId_FeeId]
ON [dbo].[TMovement] ([TenantId],[FeeId])
INCLUDE ([PractitionerId],[IsRecurring],[IncomeTypeName],[Percentage])
GO
CREATE NONCLUSTERED INDEX [IDX_TMovement_TenantId_PolicyBusinessId_IncomeTypeName]
ON [dbo].[TMovement] ([TenantId],[PolicyBusinessId],[IncomeTypeName])
INCLUDE ([PractitionerId],[IsRecurring],[IsPayawayReceived],[MovementDateTime],[GrossAmount],[IntroducerAmount],[IntroducerName],[ClientAmount],[ClientName],[AdviserAmount],[AdviserName],[NetAmount],[VATAmount])
GO
CREATE NONCLUSTERED INDEX [IDX_TMovement_TenantId_FeeId_IncomeTypeName]
ON [dbo].[TMovement] ([TenantId],[FeeId],[IncomeTypeName])
INCLUDE ([PractitionerId],[IsRecurring],[IsPayawayReceived],[MovementDateTime],[GrossAmount],[IntroducerAmount],[IntroducerName],[ClientAmount],[ClientName],[AdviserAmount],[AdviserName],[NetAmount],[VATAmount])
GO
CREATE NONCLUSTERED INDEX [IDX_TMovement_TenantId_PayAdjustId_IncomeTypeName]
ON [dbo].[TMovement] ([TenantId],[PayAdjustId],[IncomeTypeName])
INCLUDE ([MovementId])
GO
CREATE NONCLUSTERED INDEX [IDX_TMovement_LastRunDateTime]
ON [dbo].[TMovement] ([LastRunDateTime])
GO
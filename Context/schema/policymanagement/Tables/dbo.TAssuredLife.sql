CREATE TABLE [dbo].[TAssuredLife]
(
[AssuredLifeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ProtectionId] [int] NULL,
[PartyId] [int] NULL,
[BenefitId] [int] NULL,
[AdditionalBenefitId] [int] NULL,
[IndigoClientId] [int] NOT NULL,

[Title] [varchar] (255) NULL,
[FirstName] [varchar] (255) NULL,
[LastName] [varchar] (255) NULL,
[DOB] [datetime] NULL,
[GenderType] [varchar] (255) NULL,
[OrderKey] [tinyint] Null,

[ConcurrencyId] [int] NULL CONSTRAINT [DF_TAssuredLife_ConcurrencyId] DEFAULT ((1)),
[PlanMigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PolicyBusinessId] [int] NULL
)
GO
ALTER TABLE [dbo].[TAssuredLife] ADD CONSTRAINT [PK_TAssuredLife] PRIMARY KEY CLUSTERED  ([AssuredLifeId])
GO
ALTER TABLE [dbo].[TAssuredLife]  WITH CHECK ADD  CONSTRAINT [FK_TAssuredLife_BenefitId_BenefitId] FOREIGN KEY([BenefitId])
REFERENCES [dbo].[TBenefit]([BenefitId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAssuredLife_ProtectionId] ON [dbo].[TAssuredLife] ([ProtectionId]) INCLUDE ([AssuredLifeId], [BenefitId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAssuredLife_PlanMigrationRef] ON [dbo].[TAssuredLife] ([PlanMigrationRef])
GO
CREATE NONCLUSTERED INDEX IX_TAssuredLife_PolicyBusinessId ON [dbo].[TAssuredLife] ([PolicyBusinessId]) INCLUDE ([PartyId])
Go
CREATE NONCLUSTERED INDEX IX_TAssuredLife_BenefitId ON [dbo].[TAssuredLife] ([BenefitId])
GO
CREATE NONCLUSTERED INDEX IX_TAssuredLife_IndigoClientId_PartyId
ON [dbo].[TAssuredLife] (IndigoClientId, PartyId)
INCLUDE ([BenefitId],[ProtectionId])
GO
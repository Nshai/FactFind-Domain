CREATE TABLE [dbo].[TAssuredLifeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ProtectionId] [int] NULL,
[PartyId] [int] NULL,
[BenefitId] [int] NULL,
[AdditionalBenefitId] [int] NULL,
[IndigoClientId] [int] NULL,
[Title] [varchar] (255) NULL,
[FirstName] [varchar] (255) NULL,
[LastName] [varchar] (255) NULL,
[DOB] [datetime] NULL,
[GenderType] [varchar] (255) NULL,
[OrderKey] [tinyint] Null,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAssuredLifeAudit_ConcurrencyId] DEFAULT ((1)),
[AssuredLifeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAssuredLifeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PlanMigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PolicyBusinessId] [int] NULL
)
GO
ALTER TABLE [dbo].[TAssuredLifeAudit] ADD CONSTRAINT [PK_TAssuredLifeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
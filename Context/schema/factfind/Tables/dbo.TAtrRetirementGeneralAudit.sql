CREATE TABLE [dbo].[TAtrRetirementGeneralAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[AtrRetirementGeneralSyncId] [int] NULL,
[TAtrRetirementGeneralId] [int] NULL,
[CRMContactId] [int] NOT NULL,
[Client2AgreesWithAnswers] [bit] NULL,
[Client1AgreesWithProfile] [bit] NULL,
[Client2AgreesWithProfile] [bit] NULL,
[Client1ChosenProfileGuid] [uniqueidentifier] NULL,
[Client2ChosenProfileGuid] [uniqueidentifier] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrRetirementGeneralAudit_ConcurrencyId] DEFAULT ((1)),
[AtrRetirementGeneralId] [int] NOT NULL,
[StampAction] [char] (1)  NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrRetirementGeneralAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
[Client1Notes] [varchar] (5000) NULL,
[Client2Notes] [varchar] (5000) NULL,
[InconsistencyNotes] [varchar] (5000) NULL,
[CalculatedRiskProfile] [uniqueidentifier] NULL,
[RiskDiscrepency] [int] NULL,
[RiskProfileAdjustedDate] [datetime] NULL,
[AdviserNotes] [varchar] (max) NULL,
[DateOfRiskAssessment] [date] NULL,
[WeightingSum] [int] NULL,
[LowerBand] [int] NULL,
[UpperBand] [int] NULL,
[TemplateId] [int] NULL
)
GO
ALTER TABLE [dbo].[TAtrRetirementGeneralAudit] ADD CONSTRAINT [PK_TAtrRetirementGeneralAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE CLUSTERED INDEX [IDX_TAtrRetirementGeneralAudit_AtrRetirementGeneralId_ConcurrencyId] ON [dbo].[TAtrRetirementGeneralAudit] ([AtrRetirementGeneralId], [ConcurrencyId])
GO

CREATE TABLE [dbo].[TAtrInvestmentGeneralAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[Client2AgreesWithAnswers] [bit] NULL,
[Client1AgreesWithProfile] [bit] NULL,
[Client2AgreesWithProfile] [bit] NULL,
[Client1ChosenProfileGuid] [uniqueidentifier] NULL,
[Client2ChosenProfileGuid] [uniqueidentifier] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrInvestmentGeneralAudit_ConcurrencyId] DEFAULT ((1)),
[AtrInvestmentGeneralSyncId] [int] NULL,
[AtrInvestmentGeneralId] [int] NOT NULL,
[StampAction] [char] (1)  NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrInvestmentGeneralAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
[Client1Notes] [varchar] (5000) NULL,
[Client2Notes] [varchar] (5000)  NULL,
[InconsistencyNotes] [varchar] (5000)  NULL,
[CalculatedRiskProfile] [uniqueidentifier] NULL,
[RiskDiscrepency] [int] NULL,
[RiskProfileAdjustedDate] [datetime] NULL,
[AdviserNotes] [varchar] (max) NULL,
[DateOfRiskAssessment] [date] NULL,
[WeightingSum] [int] NULL,
[LowerBand] [int] NULL,
[UpperBand] [int] NULL,
TemplateId [int] NULL
)
GO
ALTER TABLE [dbo].[TAtrInvestmentGeneralAudit] ADD CONSTRAINT [PK_TAtrInvestmentGeneralAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE CLUSTERED INDEX [IDX_TAtrInvestmentGeneralAudit_AtrInvestmentGeneralId_ConcurrencyId] 
ON [dbo].[TAtrInvestmentGeneralAudit] ([AtrInvestmentGeneralId], [ConcurrencyId])
GO

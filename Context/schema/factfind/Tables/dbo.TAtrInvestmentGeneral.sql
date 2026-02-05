CREATE TABLE [dbo].[TAtrInvestmentGeneral]
(
[AtrInvestmentGeneralSyncId] [int] NULL,
[AtrInvestmentGeneralId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[Client2AgreesWithAnswers] [bit] NULL,
[Client1AgreesWithProfile] [bit] NULL,
[Client2AgreesWithProfile] [bit] NULL,
[Client1ChosenProfileGuid] [uniqueidentifier] NULL,
[Client2ChosenProfileGuid] [uniqueidentifier] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrInvestmentGeneral_ConcurrencyId] DEFAULT ((1)),
[Client1Notes] [varchar] (5000) NULL,
[Client2Notes] [varchar] (5000)  NULL,
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
ALTER TABLE [dbo].[TAtrInvestmentGeneral] ADD CONSTRAINT [PK_TAtrInvestmentGeneral] PRIMARY KEY CLUSTERED ([AtrInvestmentGeneralId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrInvestmentGeneral_CRMContactId] ON [dbo].[TAtrInvestmentGeneral] ([CRMContactId])
GO

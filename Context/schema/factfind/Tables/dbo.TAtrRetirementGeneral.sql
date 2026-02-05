CREATE TABLE [dbo].[TAtrRetirementGeneral]
(
[AtrRetirementGeneralSyncId] [int] NULL,
[AtrRetirementGeneralId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[TAtrRetirementGeneralId] [int] NULL,
[CRMContactId] [int] NOT NULL,
[Client2AgreesWithAnswers] [bit] NULL,
[Client1AgreesWithProfile] [bit] NULL,
[Client2AgreesWithProfile] [bit] NULL,
[Client1ChosenProfileGuid] [uniqueidentifier] NULL,
[Client2ChosenProfileGuid] [uniqueidentifier] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrRetirementGeneral_ConcurrencyId] DEFAULT ((1)),
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
ALTER TABLE [dbo].[TAtrRetirementGeneral] ADD CONSTRAINT [PK_TAtrRetirementGeneral] PRIMARY KEY CLUSTERED ([AtrRetirementGeneralId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrRetirementGeneral_CRMContactId] ON [dbo].[TAtrRetirementGeneral] ([CRMContactId]) 
GO

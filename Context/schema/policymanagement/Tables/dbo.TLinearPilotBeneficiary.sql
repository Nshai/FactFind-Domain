CREATE TABLE [dbo].[TLinearPilotBeneficiary]
(
[LinearPilotBeneficiaryId] [int] NOT NULL IDENTITY(1, 1),
[LinearPilotBenefitId] [int] NULL,
[BeneficiaryName] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[PercentageOfPayout] [int] NULL
)
GO
ALTER TABLE [dbo].[TLinearPilotBeneficiary] ADD CONSTRAINT [PK_TLinearPilotBeneficiary] PRIMARY KEY CLUSTERED  ([LinearPilotBeneficiaryId])
GO

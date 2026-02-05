CREATE TABLE [dbo].[TRefBenefitBasis]
(
[RefBenefitBasisID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefBenefitBasis] ADD CONSTRAINT [PK_TRefBenefitBasis] PRIMARY KEY CLUSTERED  ([RefBenefitBasisID])
GO

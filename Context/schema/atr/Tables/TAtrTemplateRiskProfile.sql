USE ATR
CREATE TABLE [dbo].[TAtrTemplateRiskProfile]
(
	[AtrTemplateRiskProfileId] [int] IDENTITY(1,1) NOT NULL,
	[AtrTemplateId] [int] NOT NULL,
	[RiskProfileId] [int] NOT NULL,
	[RiskProfileName] [varchar](255),
	[AtrRiskCode] [varchar](255),
	[LowerBand] [int] NOT NULL,
	[UpperBand] [int] NOT NULL

	CONSTRAINT [PK_AtrTemplateRiskProfileId] PRIMARY KEY CLUSTERED ([AtrTemplateRiskProfileId] ASC),
	CONSTRAINT [FK_AtrTemplate] FOREIGN KEY ([AtrTemplateId]) REFERENCES [dbo].[TAtrTemplate]([AtrTemplateId]),
	CONSTRAINT [FK_RiskProfile] FOREIGN KEY ([RiskProfileId]) REFERENCES [dbo].[TRiskProfile]([RiskProfileId]),
	CONSTRAINT [UK_AtrTemplate_AtrRiskCode] UNIQUE(RiskProfileId, AtrTemplateId, AtrRiskCode)
)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrTemplateRiskProfile_AtrTemplateId_Non_Clustered] ON [dbo].[TAtrTemplateRiskProfile] ([AtrTemplateId] ASC)
GO

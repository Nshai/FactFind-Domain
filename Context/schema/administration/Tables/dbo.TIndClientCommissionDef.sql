CREATE TABLE [dbo].[TIndClientCommissionDef]
(
[IndClientCommissionDefId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[AllowClawbackFG] [bit] NOT NULL CONSTRAINT [DF_TIndClient_AllowClawback_1__57] DEFAULT ((0)),
[DateOrder] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[PayCurrentGroupFG] [bit] NOT NULL CONSTRAINT [DF_TIndClientCommissionDef_PayCurrentGroupFG] DEFAULT ((0)),
[RecalcIntroducerSplitFG] [bit] NOT NULL CONSTRAINT [DF_TIndClientCommissionDef_RecalcIntroducerSplitFG] DEFAULT ((0)),
[RecalcPractPercentFG] [bit] NOT NULL CONSTRAINT [DF_TIndClientCommissionDef_RecalcPractPercentFG] DEFAULT ((0)),
[DefaultPayeeEntityId] [int] NULL,
[PMMaxDiffAmount] [money] NOT NULL CONSTRAINT [DF_TIndClientCommissionDef_PMMaxDiffAmount] DEFAULT ((25)),
[PMUseLinkProviderFG] [bit] NOT NULL CONSTRAINT [DF_TIndClientCommissionDef_PMUseLinkProviderFG] DEFAULT ((1)),
[PMUseLookupFG] [bit] NOT NULL CONSTRAINT [DF_TIndClientCommissionDef_PMUseLookupFG] DEFAULT ((1)),
[PMMatchSurnameFirstFG] [bit] NOT NULL CONSTRAINT [DF_TIndClientCommissionDef_PMMatchSurnameFirstFG] DEFAULT ((1)),
[PMMatchSurnameLastFG] [bit] NOT NULL CONSTRAINT [DF_TIndClientCommissionDef_PMMatchSurnameLastFG] DEFAULT ((1)),
[PMMatchCompanyNameFG] [bit] NOT NULL CONSTRAINT [DF_TIndClientCommissionDef_PMMatchCompanyNameFG] DEFAULT ((1)),
[CMUseLinkProviderFG] [bit] NOT NULL CONSTRAINT [DF_TIndClientCommissionDef_CMUseLinkProviderFG] DEFAULT ((1)),
[CMProvDescLength] [int] NOT NULL CONSTRAINT [DF_TIndClientCommissionDef_CMProvDescLength] DEFAULT ((18)),
[CMDateRangeUpper] [int] NOT NULL CONSTRAINT [DF_TIndClientCommissionDef_CMDateRangePos] DEFAULT ((14)),
[CMDateRangeLower] [int] NOT NULL CONSTRAINT [DF_TIndClientCommissionDef_CMDateRangeNeg] DEFAULT ((14)),
[MinBACSAmount] [money] NOT NULL CONSTRAINT [DF_TIndClientCommissionDef_MinBACSAmount] DEFAULT ((25)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndClient_ConcurrencyId_2__57] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TIndClientCommissionDef] ADD CONSTRAINT [PK_TIndClientCommissionDef_3__57] PRIMARY KEY NONCLUSTERED  ([IndClientCommissionDefId]) WITH (FILLFACTOR=80)
GO

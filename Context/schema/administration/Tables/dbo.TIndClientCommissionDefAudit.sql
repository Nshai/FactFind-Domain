CREATE TABLE [dbo].[TIndClientCommissionDefAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[AllowClawbackFG] [bit] NOT NULL CONSTRAINT [DF_TIndClient_AllowClawbackFG_1__56] DEFAULT ((0)),
[DateOrder] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[PayCurrentGroupFG] [bit] NOT NULL CONSTRAINT [DF_TIndClient_PayCurrentGroupFG_8__56] DEFAULT ((0)),
[RecalcIntroducerSplitFG] [bit] NOT NULL CONSTRAINT [DF_TIndClient_RecalcIntroducerSplitFG_15__56] DEFAULT ((0)),
[RecalcPractPercentFG] [bit] NOT NULL CONSTRAINT [DF_TIndClient_RecalcPractPercentFG_16__56] DEFAULT ((0)),
[DefaultPayeeEntityId] [int] NULL,
[PMMaxDiffAmount] [money] NOT NULL CONSTRAINT [DF_TIndClient_PMMaxDiffAmount_12__56] DEFAULT ((25)),
[PMUseLinkProviderFG] [bit] NOT NULL CONSTRAINT [DF_TIndClient_PMUseLinkProviderFG_13__56] DEFAULT ((1)),
[PMUseLookupFG] [bit] NOT NULL CONSTRAINT [DF_TIndClient_PMUseLookupFG_14__56] DEFAULT ((1)),
[PMMatchSurnameFirstFG] [bit] NOT NULL CONSTRAINT [DF_TIndClient_PMMatchSurnameFirstFG_10__56] DEFAULT ((1)),
[PMMatchSurnameLastFG] [bit] NOT NULL CONSTRAINT [DF_TIndClient_PMMatchSurnameLastFG_11__56] DEFAULT ((1)),
[PMMatchCompanyNameFG] [bit] NOT NULL CONSTRAINT [DF_TIndClient_PMMatchCompanyNameFG_9__56] DEFAULT ((1)),
[CMUseLinkProviderFG] [bit] NOT NULL CONSTRAINT [DF_TIndClient_CMUseLinkProviderFG_5__56] DEFAULT ((1)),
[CMProvDescLength] [int] NOT NULL CONSTRAINT [DF_TIndClient_CMProvDescLength_4__56] DEFAULT ((18)),
[CMDateRangeUpper] [int] NOT NULL CONSTRAINT [DF_TIndClient_CMDateRangeUpper_3__56] DEFAULT ((14)),
[CMDateRangeLower] [int] NOT NULL CONSTRAINT [DF_TIndClient_CMDateRangeLower_2__56] DEFAULT ((14)),
[MinBACSAmount] [money] NULL CONSTRAINT [DF_TIndClient_MinBACSAmount_7__56] DEFAULT ((25)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndClient_ConcurrencyId_6__56] DEFAULT ((1)),
[IndClientCommissionDefId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIndClient_StampDateTime_17__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIndClientCommissionDefAudit] ADD CONSTRAINT [PK_TIndClientCommissionDefAudit_18__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TIndClientCommissionDefAudit_IndClientCommissionDefId_ConcurrencyId] ON [dbo].[TIndClientCommissionDefAudit] ([IndClientCommissionDefId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

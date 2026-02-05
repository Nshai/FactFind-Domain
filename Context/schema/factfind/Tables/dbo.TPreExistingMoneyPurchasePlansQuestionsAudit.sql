CREATE TABLE [dbo].[TPreExistingMoneyPurchasePlansQuestionsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ExistingMoneyPurchaseSchemes] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[PreExistingMoneyPurchasePlansQuestionsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPreExist__Concu__75435199] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[HasPersonalPensions] [bit] NULL,
[IsPersonalPensionNonDisclosed] [bit] NULL,
[HasAnnuities] [bit] NULL,
[IsAnnuityNonDisclosed] [bit] NULL
)
GO
ALTER TABLE [dbo].[TPreExistingMoneyPurchasePlansQuestionsAudit] ADD CONSTRAINT [PK_TPreExistingMoneyPurchasePlansQuestionsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

CREATE TABLE [dbo].[TPersonalinformationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[NoMarketingInfoByPost] [bit] NULL,
[NoMarketingInfoByEmail] [bit] NULL,
[NoMarketingByPhone] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[PersonalinformationId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPersonal__Concu__04BA9F53] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPersonalinformationAudit] ADD CONSTRAINT [PK_TPersonalinformationAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

CREATE TABLE [dbo].[TRetirementAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[OccupationalScheme] [bit] NULL,
[Member] [bit] NULL,
[AVC] [bit] NULL,
[FSAVC] [bit] NULL,
[PersonalArrangements] [bit] NULL,
[OutOfS2P] [bit] NULL,
[PreviousScheme] [bit] NULL,
[PreferredRetirement] [int] NULL,
[WillRetire] [bit] NOT NULL,
[NRA] [int] NULL,
[HigherIncomeDesired] [bit] NOT NULL,
[PercentageDrop] [int] NULL,
[StatePension] [bit] NOT NULL,
[osincome] [money] NULL,
[avayincome] [money] NULL,
[fsavcincome] [money] NULL,
[paincome] [money] NULL,
[s2pincome] [money] NULL,
[psincome] [money] NULL,
[Reason] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CrmContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RetirementId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRetirementAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRetirementAudit] ADD CONSTRAINT [PK_TRetirementAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRetirementAudit_RetirementId_ConcurrencyId] ON [dbo].[TRetirementAudit] ([RetirementId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

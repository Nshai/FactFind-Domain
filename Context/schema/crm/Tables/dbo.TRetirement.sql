CREATE TABLE [dbo].[TRetirement]
(
[RetirementId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[OccupationalScheme] [bit] NULL,
[Member] [bit] NULL,
[AVC] [bit] NULL,
[FSAVC] [bit] NULL,
[PersonalArrangements] [bit] NULL,
[OutOfS2P] [bit] NULL,
[PreviousScheme] [bit] NULL,
[PreferredRetirement] [int] NULL,
[WillRetire] [bit] NOT NULL CONSTRAINT [DF_TRetirement_WillRetire] DEFAULT ((0)),
[NRA] [int] NULL,
[HigherIncomeDesired] [bit] NOT NULL CONSTRAINT [DF_TRetirement_HigherIncomeDesired] DEFAULT ((0)),
[PercentageDrop] [int] NULL,
[StatePension] [bit] NOT NULL CONSTRAINT [DF_TRetirement_StatePension] DEFAULT ((0)),
[osincome] [money] NULL,
[avayincome] [money] NULL,
[fsavcincome] [money] NULL,
[paincome] [money] NULL,
[s2pincome] [money] NULL,
[psincome] [money] NULL,
[Reason] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CrmContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRetirement_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRetirement] ADD CONSTRAINT [PK_TRetirement_RetirementId] PRIMARY KEY CLUSTERED  ([RetirementId]) WITH (FILLFACTOR=80)
GO

CREATE TABLE [dbo].[TAccountType]
(
[AccountTypeId] [int] NOT NULL IDENTITY(1, 1),
[AccountTypeName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[IsForCorporate] [bit] NULL,
[IsForIndividual] [bit] NULL,
[IsNotModifiable] [bit] NOT NULL CONSTRAINT [DF__TAccountT__IsNot__26CA629E] DEFAULT ((0)),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF__TAccountT__IsArc__27BE86D7] DEFAULT ((0)),
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAccountType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAccountType] ADD CONSTRAINT [PK_TAccountType] PRIMARY KEY CLUSTERED  ([AccountTypeId])
GO

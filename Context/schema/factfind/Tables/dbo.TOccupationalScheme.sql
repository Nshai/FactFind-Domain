CREATE TABLE [dbo].[TOccupationalScheme]
(
[OccupationalSchemeId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[NameOfScheme] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[TypeOfScheme] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Insurer] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[PlanContractedOutOfS2P] [bit] NULL,
[PaymentBasis] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TOccupati__Concu__51700577] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TOccupationalScheme_CRMContactId] ON [dbo].[TOccupationalScheme] ([CRMContactId]) WITH (FILLFACTOR=80)
GO

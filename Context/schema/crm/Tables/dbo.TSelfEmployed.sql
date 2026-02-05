CREATE TABLE [dbo].[TSelfEmployed]
(
[SelfEmployedId] [int] NOT NULL IDENTITY(1, 1),
[OccupationId] [int] NOT NULL,
[RefNatureOfEmploymentId] [int] NULL,
[EstablishedDate] [datetime] NULL,
[YearEnd] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[EstimatedNRE] [money] NULL,
[Drawings] [money] NULL,
[NRE1] [money] NULL,
[NRE1TaxYear] [datetime] NULL,
[NRE2] [money] NULL,
[NRE2TaxYear] [datetime] NULL,
[NRE3] [money] NULL,
[NRE3TaxYear] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSelfEmplo_ConcurrencyId_1__57] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSelfEmployed] ADD CONSTRAINT [PK_TSelfEmployed_2__57] PRIMARY KEY NONCLUSTERED  ([SelfEmployedId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TSelfEmployed_OccupationId] ON [dbo].[TSelfEmployed] ([OccupationId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TSelfEmployed_RefNatureOfEmploymentId] ON [dbo].[TSelfEmployed] ([RefNatureOfEmploymentId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TSelfEmployed] ADD CONSTRAINT [FK_TSelfEmployed_RefNatureOfEmploymentId_RefNatureOfEmploymentId] FOREIGN KEY ([RefNatureOfEmploymentId]) REFERENCES [dbo].[TRefNatureOfEmployment] ([RefNatureOfEmploymentId])
GO

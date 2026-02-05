CREATE TABLE [dbo].[TSelfEmployedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
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
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[SelfEmployedId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TSelfEmplo_StampDateTime_1__107] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSelfEmployedAudit] ADD CONSTRAINT [PK_TSelfEmployedAudit_2__107] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TSelfEmployedAudit_SelfEmployedId_ConcurrencyId] ON [dbo].[TSelfEmployedAudit] ([SelfEmployedId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

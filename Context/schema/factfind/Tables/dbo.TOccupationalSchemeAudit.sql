CREATE TABLE [dbo].[TOccupationalSchemeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[NameOfScheme] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[TypeOfScheme] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Insurer] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[PlanContractedOutOfS2P] [bit] NULL,
[PaymentBasis] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[OccupationalSchemeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TOccupati__Concu__25276EE5] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOccupationalSchemeAudit] ADD CONSTRAINT [PK_TOccupationalSchemeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

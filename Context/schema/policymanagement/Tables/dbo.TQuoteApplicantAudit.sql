CREATE TABLE [dbo].[TQuoteApplicantAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQuoteApplicantAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[QuoteApplicantId] [int] NULL,
[RefEmploymentStatusId] [int] NULL,
[EmployerName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[EmploymentMonths] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[JobRole] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[JobIndustry] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[EmployerAddressId] [int] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TQuoteApplicantAudit_ConcurrencyId] DEFAULT ((1)),
[PartyId] [int] NULL,
[ProductApplicationId] [int] NULL,
[PropertyDetailId] [int] NULL
)
GO
ALTER TABLE [dbo].[TQuoteApplicantAudit] ADD CONSTRAINT [PK_TQuoteApplicantAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

CREATE TABLE [dbo].[TDetailedincomebreakdownAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Owner] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Amount] [money] NULL,
[HasIncludeInAffordability] [bit] NULL,
[Frequency] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[IncomeType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[CRMContactId2] [int] NULL,
[DetailedincomebreakdownId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TDetailed__Concu__56F3D4A3] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[GrossOrNet] [bit] NULL,
[GrossAmountDescription] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[EmploymentDetailIdValue] [int] NULL,
[NetAmount] [money] NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[PolicyBusinessId] [int] NULL,
[WithdrawalId] [int] NULL,
[LastUpdatedDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TDetailedincomebreakdownAudit] ADD CONSTRAINT [PK_TDetailedincomebreakdownAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

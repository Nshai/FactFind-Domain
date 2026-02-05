CREATE TABLE [dbo].[TSavingsFFExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ExistingDeposits] [bit] NULL,
[NonDisclosureCash] [bit] NULL,
[OtherInvestments] [bit] NULL,
[GoalsAndNeeds] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NextSteps] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NonDisclosureOther] [bit] NULL,
[Client1Total] [money] NULL,
[Client2Total] [money] NULL,
[JointTotal] [money] NULL,
[ConcurrencyId] [int] NOT NULL,
[SavingsFFExtId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSavingsFFExtAudit] ADD CONSTRAINT [PK_TSavingsFFExtAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

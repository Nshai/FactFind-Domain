CREATE TABLE [dbo].[TChecklistAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[producttypes] [bit] NULL,
[repaymentmethods] [bit] NULL,
[interestonly] [bit] NULL,
[interestonlyrepaymentmethods] [bit] NULL,
[nonrepaymentconsequences] [bit] NULL,
[customerresponsibility] [bit] NULL,
[earlyrepaymentconsequences] [bit] NULL,
[relatedinsurances] [bit] NULL,
[insuranceresponsibility] [bit] NULL,
[explaininsuranceconditions] [bit] NULL,
[costsandfees] [bit] NULL,
[portableterms] [bit] NULL,
[detailspassedtocra] [bit] NULL,
[higherlendingcharge] [bit] NULL,
[circumstancechangeconsequences] [bit] NULL,
[jointapplications] [bit] NULL,
[addingfeestoloan] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TChecklistAudit_ConcurrencyId] DEFAULT ((1)),
[ChecklistId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TChecklistAudit] ADD CONSTRAINT [PK_TChecklistAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO

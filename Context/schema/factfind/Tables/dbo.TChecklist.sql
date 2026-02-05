CREATE TABLE [dbo].[TChecklist]
(
[ChecklistId] [int] NOT NULL IDENTITY(1, 1),
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
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TChecklist_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TChecklist] ADD CONSTRAINT [PK_TChecklist] PRIMARY KEY NONCLUSTERED  ([ChecklistId]) WITH (FILLFACTOR=80)
GO

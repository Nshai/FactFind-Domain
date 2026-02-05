CREATE TABLE [dbo].[TEstateNextStepsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[NextSteps] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[EstateNextStepsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEstateNe__Concu__1980B20F] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEstateNextStepsAudit] ADD CONSTRAINT [PK_TEstateNextStepsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

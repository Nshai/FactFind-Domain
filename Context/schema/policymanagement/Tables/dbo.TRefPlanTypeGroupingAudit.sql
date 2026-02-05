CREATE TABLE [dbo].[TRefPlanTypeGroupingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanTypeId] [int] NOT NULL,
[IsMortgage] [bit] NOT NULL CONSTRAINT [DF_TRefPlanTypeGroupingAudit_IsMortgage] DEFAULT ((0)),
[IsTerm] [bit] NOT NULL CONSTRAINT [DF_TRefPlanTypeGroupingAudit_IsTerm] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanTypeGroupingAudit_ConcurrencyId] DEFAULT ((1)),
[RefPlanTypeGroupingId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefPlanTypeGroupingAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefPlanTypeGroupingAudit] ADD CONSTRAINT [PK_TRefPlanTypeGroupingAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO

CREATE TABLE [dbo].[TRefPlanTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PlanTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[WebPage] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[OrigoRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[QuoteRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[NBRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [tinyint] NULL,
[RetireDate] [datetime] NULL,
[FindFg] [tinyint] NULL,
[SchemeType] [tinyint] NOT NULL CONSTRAINT [DF_TRefPlanTypeAudit_SchemeType] DEFAULT ((0)),
[IsWrapperFg] [bit] NOT NULL CONSTRAINT [DF_TRefPlanTypeAudit_IsWrapperFg] DEFAULT ((0)),
[AdditionalOwnersFg] [bit] NOT NULL CONSTRAINT [DF_TRefPlanTypeAudit_AdditionalOwnersFg] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanTy_ConcurrencyId_1__56] DEFAULT ((1)),
[RefPlanTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefPlanTy_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsTaxQualifying] [bit] NULL
)
GO
ALTER TABLE [dbo].[TRefPlanTypeAudit] ADD CONSTRAINT [PK_TRefPlanTypeAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefPlanTypeAudit_RefPlanTypeId_ConcurrencyId] ON [dbo].[TRefPlanTypeAudit] ([RefPlanTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO

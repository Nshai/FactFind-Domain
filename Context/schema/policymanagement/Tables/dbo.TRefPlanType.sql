CREATE TABLE [dbo].[TRefPlanType]
(
[RefPlanTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PlanTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[WebPage] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[OrigoRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[QuoteRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[NBRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [tinyint] NULL CONSTRAINT [DF_TRefPlanType_RetireFg] DEFAULT ((0)),
[RetireDate] [datetime] NULL,
[FindFg] [tinyint] NULL,
[SchemeType] [tinyint] NOT NULL CONSTRAINT [DF_TRefPlanType_SchemeType] DEFAULT ((0)),
[IsWrapperFg] [bit] NOT NULL CONSTRAINT [DF_TRefPlanType_IsWrapperFg] DEFAULT ((0)),
[AdditionalOwnersFg] [bit] NOT NULL CONSTRAINT [DF_TRefPlanType_AdditionalOwnersFg] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanTy_ConcurrencyId_1__63] DEFAULT ((1)),
[IsTaxQualifying] [bit] NULL
)
GO
ALTER TABLE [dbo].[TRefPlanType] ADD CONSTRAINT [PK_TRefPlanType_2__63] PRIMARY KEY NONCLUSTERED  ([RefPlanTypeId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TRefPlanType_RefPlanTypeId] ON [dbo].[TRefPlanType] ([RefPlanTypeId])
GO

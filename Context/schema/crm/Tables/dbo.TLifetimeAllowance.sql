CREATE TABLE [dbo].[TLifetimeAllowance](
	[LifetimeAllowanceId] [int] IDENTITY(1,1) NOT NULL,
	[TenantId] [int] NOT NULL,
	[CrmContactId] [int] NOT NULL,
	[DateOfBCE] [datetime] NULL,
	[PercentOfUsedLTA] [decimal](5, 2) NULL,
	[LumpSumTaxFreeAmount] [money] NULL,
	[RelatedPlanId] [int] NULL,
	[RelatedNonRecorderedPlan] [varchar] (200) NULL,
	[TotalCrystallisedAmount] [money] NULL,
	[HasSeriousIllHealthLumpSum] [bit] NOT NULL CONSTRAINT [DF_TLifetimeAllowance_HasSeriousIllHealthLumpSum] DEFAULT ((0)),
	[HasAge75Test] [bit] NOT NULL CONSTRAINT [DF_TLifetimeAllowance_HasAge75Test] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TLifetimeAllowance] ADD CONSTRAINT [PK_TLifetimeAllowanceId] PRIMARY KEY CLUSTERED  ([LifetimeAllowanceId], [TenantId])
GO
CREATE NONCLUSTERED INDEX [IX_TLifetimeAllowance_CrmContactId] ON [dbo].[TLifetimeAllowance] ([CrmContactId])
GO
ALTER TABLE [dbo].[TLifetimeAllowance] WITH CHECK ADD CONSTRAINT [FK_TLifetimeAllowance_CrmContactId] FOREIGN KEY([CrmContactId])
REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
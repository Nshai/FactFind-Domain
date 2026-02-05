CREATE TABLE [dbo].[TDetailedincomebreakdown]
(
[DetailedincomebreakdownId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[CRMContactId2] [int] NULL,
[Owner] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Amount] [money] NULL,
[HasIncludeInAffordability] [bit] NOT NULL CONSTRAINT [DF_TDetailedincomebreakdown_HasIncludeInAffordability] DEFAULT ((0)),
[Frequency] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[IncomeType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TDetailed__Concu__033C6B35] DEFAULT ((1)),
[GrossOrNet] [bit] NOT NULL CONSTRAINT [DF_TDetailedincomebreakdown_GrossOrNet] DEFAULT ((0)),
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
ALTER TABLE [dbo].[TDetailedincomebreakdown] ADD CONSTRAINT [PK_TDetailedincomebreakdown] PRIMARY KEY CLUSTERED ([DetailedincomebreakdownId])
GO
CREATE NONCLUSTERED INDEX [IDX_TDetailedincomebreakdown_CRMContactId] ON [dbo].[TDetailedincomebreakdown] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TDetailedincomebreakdown_CRMContactId2] ON [dbo].[TDetailedincomebreakdown] ([CRMContactId2])
GO
CREATE NONCLUSTERED INDEX [IDX_TDetailedincomebreakdown_EmploymentDetailIdValue_EndDate] ON [dbo].[TDetailedincomebreakdown] ([EmploymentDetailIdValue], [EndDate])
GO

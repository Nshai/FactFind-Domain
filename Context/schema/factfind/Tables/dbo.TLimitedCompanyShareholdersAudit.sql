CREATE TABLE [dbo].[TLimitedCompanyShareholdersAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ShareHolderName] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ShareHolderRole] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[DOB] [datetime] NULL,
[Smoker] [bit] NULL,
[DateJoinedCompany] [datetime] NULL,
[CurrentValue] [money] NULL,
[PercentageInterest] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CurrentYear] [money] NULL,
[LastYear] [money] NULL,
[TwoYearsAgo] [money] NULL,
[InGoodHealth] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[LimitedcompanyshareholdersId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TLimitedCompanyShareholdersAudit__ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLimitedCompanyShareholdersAudit] ADD CONSTRAINT [PK_TLimitedCompanyShareholdersAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO

CREATE TABLE [dbo].[TEmploymentHistory]
(
[EmploymentHistoryId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEmploymentHistory_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NOT NULL,
[Employer] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[GrossAnnualEarnings] [money] NULL,
[IsCurrentEmployment] [bit] NULL,
[EmploymentDetailId] [int] NULL
)
GO
ALTER TABLE [dbo].[TEmploymentHistory] ADD CONSTRAINT [PK_TEmploymentHistory] PRIMARY KEY NONCLUSTERED  ([EmploymentHistoryId])
GO

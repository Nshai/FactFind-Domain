CREATE TABLE [dbo].[TAccountJobDetail]
(
[AccountJobDetailId] [int] NOT NULL IDENTITY(1, 1),
[AccountId] [int] NOT NULL,
[JobTitle] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[EmployerCRMId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAccountJobDetail_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAccountJobDetail] ADD CONSTRAINT [PK_TAccountJobDetail] PRIMARY KEY CLUSTERED  ([AccountJobDetailId])
GO

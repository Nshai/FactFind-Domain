CREATE TABLE [dbo].[TRefInitialEarningsPeriod]
(
[RefInitialEarningsPeriodId] [int] NOT NULL IDENTITY(1, 1),
[InitialEarningsPeriod] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TRefInitialEarningsPeriod_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRefInitialEarningsPeriod] ADD CONSTRAINT [PK_TRefInitialEarningsPeriod] PRIMARY KEY CLUSTERED  ([RefInitialEarningsPeriodId])
GO

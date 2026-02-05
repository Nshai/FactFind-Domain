CREATE TABLE [dbo].[TValProviderHoursOfOperation]
(
[ValProviderHoursOfOperationId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NOT NULL,
[AlwaysAvailableFg] [bit] NOT NULL,
[DayOfTheWeek] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[StartHour] [tinyint] NOT NULL CONSTRAINT [DF_TValProviderHoursOfOperation_StartHour] DEFAULT ((0)),
[EndHour] [tinyint] NOT NULL CONSTRAINT [DF_TValProviderHoursOfOperation_EndHour] DEFAULT ((0)),
[StartMinute] [tinyint] NOT NULL CONSTRAINT [DF_TValProviderHoursOfOperation_StartMinute] DEFAULT ((0)),
[EndMinute] [tinyint] NOT NULL CONSTRAINT [DF_TValProviderHoursOfOperation_EndMinute] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValProviderHoursOfOperation_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValProviderHoursOfOperation] ADD CONSTRAINT [PK_TValProviderHoursOfOperation] PRIMARY KEY NONCLUSTERED  ([ValProviderHoursOfOperationId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TValProviderHoursOfOperation_RefProdProviderId] ON [dbo].[TValProviderHoursOfOperation] ([RefProdProviderId])
GO

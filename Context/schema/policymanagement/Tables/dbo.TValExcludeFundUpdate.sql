CREATE TABLE [dbo].[TValExcludeFundUpdate]
(
[ValExcludeFundUpdateId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ValScheduleId] [int] NOT NULL,
[ValGatingId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_Tmp_ValExcludeFundUpdate_ConcurrencyId] DEFAULT (1),
)
GO
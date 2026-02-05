CREATE TABLE [dbo].[TRefWaitingPeriod]
(
[RefWaitingPeriodId] [int] NOT NULL IDENTITY(1, 1),
[Descriptor] [varchar] (25) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFG] [bit] NOT NULL,
[IndigoClientId] [int] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO

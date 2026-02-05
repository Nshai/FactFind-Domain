CREATE TABLE [dbo].[TRefContributionPercentage]
(
[RefContributionPercentageId] [int] NOT NULL IDENTITY(1, 1),
[Descriptor] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFG] [bit] NOT NULL,
[DPMapping] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO

CREATE TABLE [dbo].[TPortfolioConstructionPreference]
(
[PortfolioConstructionPreferenceId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NULL,
[PreferenceName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Value] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO

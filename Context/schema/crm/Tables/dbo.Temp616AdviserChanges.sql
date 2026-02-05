CREATE TABLE [dbo].[Temp616AdviserChanges]
(
[ColId] [int] NOT NULL IDENTITY(1, 1),
[PlanRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[PolicyBusinessId] [int] NULL,
[OriginalAdviser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[OriginalPractitionerId] [int] NULL,
[NewAdviser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[NewPractitionerId] [int] NULL,
[NewBandingTemplateId] [int] NULL
)
GO
ALTER TABLE [dbo].[Temp616AdviserChanges] ADD CONSTRAINT [PK__Temp616AdviserCh__252B6798] PRIMARY KEY CLUSTERED  ([ColId])
GO

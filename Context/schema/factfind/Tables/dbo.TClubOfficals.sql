CREATE TABLE [dbo].[TClubOfficals]
(
[ClubOfficalsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ClubOfficialName] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ClubOfficialRole] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[DOB] [datetime] NULL,
[SmokerYesNo] [bit] NULL,
[GoodHealth] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TClubOffi__Concu__18027DF1] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TClubOfficals_CRMContactId] ON [dbo].[TClubOfficals] ([CRMContactId]) WITH (FILLFACTOR=80)
GO

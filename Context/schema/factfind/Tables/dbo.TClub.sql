CREATE TABLE [dbo].[TClub]
(
[ClubId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[OtherEmployeesToBeProtected] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClub_ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TClub_CRMContactId] ON [dbo].[TClub] ([CRMContactId]) WITH (FILLFACTOR=80)
GO

CREATE TABLE [dbo].[TMortgageRequireStatus]
(
[MortgageRequireStatusId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ExPat] [bit] NULL,
[ForeignCitizen] [bit] NULL,
[Status] [bit] NULL,
[SelfCert] [bit] NULL,
[NonStatus] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageRequireStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMortgageRequireStatus] ADD CONSTRAINT [PK_TMortgageRequireStatus] PRIMARY KEY NONCLUSTERED  ([MortgageRequireStatusId]) WITH (FILLFACTOR=80)
GO

CREATE TABLE [dbo].[TExWebQuote]
(
[ExWebQuoteId] [int] NOT NULL IDENTITY(1, 1),
[PractitionerId] [int] NOT NULL,
[CRMContactId1] [int] NULL,
[CRMContactId2] [int] NULL,
[Basis] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Date] [datetime] NOT NULL,
[Status] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Type] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ServiceType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Reference] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Request] [text] COLLATE Latin1_General_CI_AS NOT NULL,
[Response] [text] COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TExWebQuote_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TExWebQuote] ADD CONSTRAINT [PK_TExWebQuote] PRIMARY KEY CLUSTERED  ([ExWebQuoteId]) WITH (FILLFACTOR=80)
GO

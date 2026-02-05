CREATE TABLE [dbo].[TMortgageSourceRequestError]
(
[ErrorDate] [datetime] NULL,
[UserId] [int] NULL,
[OpportunityId] [int] NULL,
[FullQuoteId] [int] NULL,
[Request] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Response] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL
)
GO

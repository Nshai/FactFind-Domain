CREATE TABLE [dbo].[TArrearExt]
(
[ArrearExtId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[BeenInArrearsFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TArrearExt_ConcurrencyId] DEFAULT ((1))
)
GO

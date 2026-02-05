CREATE TABLE [dbo].[TPolicyNumberFormat]
(
[PolicyNumberFormatId] [int] NOT NULL IDENTITY(1, 1),
[UserFormat] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[Example] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[RegularExpression] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[RefPlanTypeId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO

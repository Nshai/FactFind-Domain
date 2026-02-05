CREATE TABLE [dbo].[TRefEquityLoanScheme]
(
[RefEquityLoanSchemeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TRefEquityLoanScheme] ADD CONSTRAINT [PK_TRefEquityLoanScheme] PRIMARY KEY CLUSTERED  ([RefEquityLoanSchemeId])
GO
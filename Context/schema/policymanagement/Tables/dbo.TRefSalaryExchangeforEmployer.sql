CREATE TABLE [dbo].[TRefSalaryExchangeforEmployer]
(
[RefSalaryExchangeforEmployerId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefSalaryExchangeforEmployer] ADD CONSTRAINT [PK_TRefSalaryExchangeforEmployer] PRIMARY KEY CLUSTERED  ([RefSalaryExchangeforEmployerId])
GO

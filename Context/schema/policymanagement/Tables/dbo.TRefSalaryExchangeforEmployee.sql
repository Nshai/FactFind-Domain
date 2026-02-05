CREATE TABLE [dbo].[TRefSalaryExchangeforEmployee]
(
[RefSalaryExchangeforEmployeeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefSalaryExchangeforEmployee] ADD CONSTRAINT [PK_TRefSalaryExchangeforEmployee] PRIMARY KEY CLUSTERED  ([RefSalaryExchangeforEmployeeId])
GO

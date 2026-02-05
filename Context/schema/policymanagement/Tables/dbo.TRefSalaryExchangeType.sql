CREATE TABLE [dbo].[TRefSalaryExchangeType]
(
[RefSalaryExchangeTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefSalaryExchangeType] ADD CONSTRAINT [PK_TRefSalaryExchange] PRIMARY KEY CLUSTERED  ([RefSalaryExchangeTypeId])
GO

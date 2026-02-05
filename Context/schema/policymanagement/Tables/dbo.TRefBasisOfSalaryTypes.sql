CREATE TABLE [dbo].[TRefBasisOfSalaryTypes]
(
[RefBasisOfSalaryTypesId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefBasisOfSalaryTypes] ADD CONSTRAINT [PK_TRefBasisOfSalaryTypes] PRIMARY KEY CLUSTERED  ([RefBasisOfSalaryTypesId])
GO

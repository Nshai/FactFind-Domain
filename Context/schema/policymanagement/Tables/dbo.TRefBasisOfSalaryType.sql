CREATE TABLE [dbo].[TRefBasisOfSalaryType]
(
[RefBasisOfSalaryTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefBasisOfSalaryType] ADD CONSTRAINT [PK_TRefBasisOfSalaryType] PRIMARY KEY CLUSTERED  ([RefBasisOfSalaryTypeId])
GO

CREATE TABLE [dbo].[TRefBasisOfSalaryAsAtType]
(
[RefBasisOfSalaryAsAtTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefBasisOfSalaryAsAtType] ADD CONSTRAINT [PK_TRefBasisOfSalaryAsAtType] PRIMARY KEY CLUSTERED  ([RefBasisOfSalaryAsAtTypeId])
GO

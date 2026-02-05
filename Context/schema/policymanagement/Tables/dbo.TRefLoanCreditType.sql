CREATE TABLE [dbo].[TRefLoanCreditType]
(
[RefLoanCreditTypeId] int NOT NULL IDENTITY(1,1),
[Name] varchar(50) NULL
)
GO

ALTER TABLE [dbo].[TRefLoanCreditType] 
ADD CONSTRAINT [PK_TRefLoanCreditType] 
PRIMARY KEY NONCLUSTERED  ([RefLoanCreditTypeId])
GO

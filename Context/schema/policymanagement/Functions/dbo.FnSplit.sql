SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION dbo.FnSplit
(
	@List nvarchar(max),
	@SplitOn nvarchar(5)
)  
RETURNS @RtnValue table 
(
		
	Id int identity(1,1),
	Value nvarchar(100)
) 
AS  
BEGIN

While (Charindex(@SplitOn,@List)>0)
Begin  
Insert Into @RtnValue (value)
Select 
    Value = ltrim(rtrim(Substring(@List,1,Charindex(@SplitOn,@List)-1)))  
    Set @List = Substring(@List,Charindex(@SplitOn,@List)+len(@SplitOn),len(@List))
End  

    Insert Into @RtnValue (Value)
    Select Value = ltrim(rtrim(@List))

    Return
END
 

/*
Usage

Select 
   employeeId, -- integer (int)
   FirstName, 
   LastName 
from #myTable
Where 
   employeeId IN (Select convert(int,Value) from dbo.FnSplit(@employeeList,','))

*/


GO

Create Procedure SpCustomParseCsvStringToStringList
	@CommaSeperatedList varchar(2000) 
As

If ISNULL(@CommaSeperatedList,'') = '' 
	return
	
--Declare @InternalListOfIds  varchar(2000)      
Select @CommaSeperatedList = LTrim(RTrim(@CommaSeperatedList))      
If Right(@CommaSeperatedList, 1) <> ',' Select @CommaSeperatedList = @CommaSeperatedList + ','      
If Left(@CommaSeperatedList, 1) <> ',' Select @CommaSeperatedList = ',' + @CommaSeperatedList      
      
Declare @ParsedValues Table ( Id int Identity(1,1), ParsedValue varchar(200) )      
   
Select Top 11000 Identity(int,1,1) AS N         
Into #Tally      
From master.dbo.SysColumns sc1,              
master.dbo.SysColumns sc2      
  
declare @sql nvarchar(255) = N'
Alter Table #Tally
Add Constraint PK_Tally_N' + cast(@@spid as nvarchar) + N'
Primary Key Clustered (N) With FillFactor = 100'
exec sp_executesql @sql

Insert Into @ParsedValues      
( ParsedValue )       
Select substring(@CommaSeperatedList, N+1, CHARINDEX(',', @CommaSeperatedList, N+1) -N -1)         
FROM #Tally        
WHERE N < LEN(@CommaSeperatedList) AND SUBSTRING(@CommaSeperatedList, N, 1) = ','  

Select Id, ParsedValue From @ParsedValues

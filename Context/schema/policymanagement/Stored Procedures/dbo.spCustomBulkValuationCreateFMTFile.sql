create procedure spCustomBulkValuationCreateFMTFile
as
declare @dircheck table (File_Exists int,File_is_a_Directory int,Parent_Directory_Exists int)
declare @fmtlocation sysname= '\\'+convert(sysname,SERVERPROPERTY('InstanceName'))+'\scratch\valuation.fmt', @fmtlocationfile sysname

insert @dircheck 
exec xp_fileexist  @fmtlocation

if not exists (select * from @dircheck where Parent_Directory_Exists = 1)
begin
	select @fmtlocation = 'c:\temp'
	delete @dircheck 
end
select @fmtlocationfile = @fmtlocation+'\valuation.fmt'

insert @dircheck 
exec xp_fileexist  @fmtlocationfile 

if not exists (select * from @dircheck where File_Exists = 1)
begin
exec sp_writefile 
'9.0
14
1	SQLCHAR	0	8000	"|"	1	CustomerReference                               ""	
2	SQLCHAR	0	8000	"|"	2	PortfolioReference                              ""	
3	SQLCHAR	0	8000	"|"	21	PortfolioType	                                ""	
4	SQLCHAR	0	8000	"|"	29	EffectiveDate	                                ""	
5	SQLCHAR	0	8000	"|"	25	ISIN	                                        ""	
6	SQLCHAR	0	8000	"|"	24	FundName	                                ""	
7	SQLCHAR	0	8000	"|"	30	Price	                                        ""	
8	SQLCHAR	0	8000	"|"	28	Quantity	                                ""	
9	SQLCHAR	0	8000	"|"	32	HoldingValue	                                ""	
10	SQLCHAR	0	8000	"|"	33	Currency	                                ""	
11	SQLCHAR	0	8000	"|"	0	zzIGNOREzz_1	                                ""	
12	SQLCHAR	0	8000	"|"	16	AdviserLastName	                                ""	
13	SQLCHAR	0	8000	"|"	6	CustomerLastName                                ""	
14	SQLCHAR	0	8000	"\r\n"	13	ClientPostCode	                                ""
',@fmtlocation,'valuation.fmt'
end


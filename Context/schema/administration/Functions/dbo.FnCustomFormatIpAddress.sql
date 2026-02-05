SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create function [dbo].[FnCustomFormatIpAddress] (@ipaddress varchar(25)) 
returns varchar(25)
with schemabinding
as
begin
    set @ipaddress = '.' + @ipaddress + '.' + 
                     case when parsename(@ipaddress,1) is null then '' else '000.000.' end
    while LEN(@ipaddress) < 25
    begin
        set @ipaddress = ISNULL(STUFF(@ipaddress,PATINDEX('%[.]_[.]%',@ipaddress),1,'.00'),@ipaddress)
        set @ipaddress = ISNULL(STUFF(@ipaddress,PATINDEX('%[.]__[.]%',@ipaddress),1,'.0'),@ipaddress)
    end
    return substring(left(@ipaddress,len(@ipaddress)-1),2,50)
end
GO

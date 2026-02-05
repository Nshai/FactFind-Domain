SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure dbo.spValidateTenantCloning @SourceIndigoClientId bigint, @msg varchar(max) OUTPUT
as
begin
declare @CloneAccountName varchar(100),
  @NumRecs int,
  @RetCode int = 0

select @CloneAccountName = Identifier from Administration.dbo.TIndigoClient WHERE IndigoClientId = @SourceIndigoClientId
set @msg = 'Cloning your new Tenant based off of ' + @CloneAccountName + '''s Account. Tenant ' + CONVERT(VARCHAR(250),@SourceIndigoClientId)

raiserror(@msg,0,1) with nowait

set @msg = ''

select @NumRecs = count(1) from Administration.dbo.TGroup where IndigoClientId = @SourceIndigoClientId and ParentId is null
if @NumRecs>1 begin
	set @msg += '

-----------------------------------------------------------
Source tenant ' + @CloneAccountName + ' has '+convert(varchar(10), @NumRecs)+' top tier groups! (groups without ParentId).
Only one is allowed. PLEASE FIX THE DATA!
-----------------------------------------------------------'
  set @RetCode = -1
end

select @NumRecs = count(1) from CRM..TRefIntroducerType where LongName Like '%UnApproved%' and IndClientId = @SourceIndigoClientId
if @NumRecs>1 begin
	set @msg += '

-----------------------------------------------------------
Source tenant ' + @CloneAccountName + ' has '+convert(varchar(10), @NumRecs)+' records in CRM..TRefIntroducerType LIKE ''%UnApproved%''!
The configuration Script will fail.
Only one UnApproved record is allowed. PLEASE FIX THE DATA!
-----------------------------------------------------------'
	set @RetCode = -1
end

if @RetCode!=0 begin
  select [ERROR] = @msg
  raiserror(@msg,0,1) with nowait
end

return @RetCode
  
end
GO

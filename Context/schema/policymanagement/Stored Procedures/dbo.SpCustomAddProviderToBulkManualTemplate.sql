set quoted_identifier on
go
set ansi_nulls on
go
create procedure [dbo].[SpCustomAddProviderToBulkManualTemplate]
@RefProdProviderid int,
@PublicList bit,
@ClosePrivateList bit
AS  

begin
	set nocount on
	set transaction isolation level read uncommitted

	declare @stampdatetime datetime2 = getdate(), @stampuser int = '0'
	declare @providername varchar(255)
	declare @result table (description varchar(1000))

	select @providername = name from VProvider where RefProdProviderId = @RefProdProviderid

	if not exists (select 1 from vprovider where RefProdProviderId = @RefProdProviderid)
	begin
		select ('Provider [' + convert(varchar(100),@RefProdProviderid) + '] Does not exist, Cannot continue!')
		return
	end

	if (coalesce(@PublicList, 0) <> 0)
	begin

		if exists (select 1 from TValTemplateProvider where IndigoClientId is null and RefProdProviderId = @RefProdProviderid)
		begin
			insert into @result values ('[' + @providername + '] already exists in the public list')
		end
		else
		begin
			insert into [dbo].[tvaltemplateprovider]
				([indigoclientid],[refprodproviderid],[concurrencyid])
				output 
					inserted.[valtemplateproviderid],inserted.[indigoclientid],inserted.[refprodproviderid]
					,inserted.[concurrencyid],'C',@stampdatetime, @stampuser
				into [dbo].[tvaltemplateprovideraudit]
					([valtemplateproviderid],[indigoclientid],[refprodproviderid]
					,[concurrencyid],[stampaction],[stampdatetime],[stampuser])
				select null, refprodproviderid, 1 from VProvider where RefProdProviderId = @RefProdProviderid
			
			insert into @result values ('[' + @providername + '] added to the public list')

		end
	end

	if (coalesce(@ClosePrivateList, 0) <> 0)
	begin

		declare @CloseIndigoId int, @closeIndigoName varchar(255) = 'Close Brothers Asset Management'

		select @CloseIndigoId = IndigoClientId from administration..TIndigoClient where identifier like @closeIndigoName 

		if coalesce(@CloseIndigoId, 0) <> 0
		begin

			if exists (select 1 from TValTemplateProvider where IndigoClientId = @CloseIndigoId and RefProdProviderId = @RefProdProviderid)
			begin
				insert into @result values ('[' + @providername + '] already exists in the [' + @closeIndigoName +'] private list')
			end
			else
			begin
				insert into [dbo].[tvaltemplateprovider]
					([indigoclientid],[refprodproviderid],[concurrencyid])
					output 
						inserted.[valtemplateproviderid],inserted.[indigoclientid],inserted.[refprodproviderid]
						,inserted.[concurrencyid],'C',@stampdatetime, @stampuser
					into [dbo].[tvaltemplateprovideraudit]
						([valtemplateproviderid],[indigoclientid],[refprodproviderid]
						,[concurrencyid],[stampaction],[stampdatetime],[stampuser])
					select @CloseIndigoId, refprodproviderid, 1 from VProvider where RefProdProviderId = @RefProdProviderid
				
				insert into @result values ('[' + @providername + '] added to the [' + @closeIndigoName +'] private list')
			end
		end
		else
		begin
			insert into @result values ('[' + @closeIndigoName + '] doesnot exist!')
		end
	end

	select * from @result

end
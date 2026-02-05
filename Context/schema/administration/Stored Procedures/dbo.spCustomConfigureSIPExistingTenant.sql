SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spCustomConfigureSIPExistingTenant] @NewTenantId bigint
AS

Declare @SimplyBizNetworkAccountTenantId bigint, @NewTenantGuid varchar(255)

Set @SimplyBizNetworkAccountTenantId = 747 -- tenantid

Select @NewTenantGuid=GUID from Administration..TIndigoClient where IndigoClientId=@NEwTenantId

-- lets mark the tenant record
Update Administration..TIndigoClient set networkid=@SimplyBizNetworkAccountTenantId  where IndigoClientId=@NewTenantId


-- lets deal with the check lists we need to archive existing first
update compliance..TCheckListQuestion Set IsArchived=1, Question=Question + '-archived' where tenantid=@NewTenantId
update compliance..TCheckListCategory Set IsArchived=1, CategoryName=CategoryName + '-archived' where tenantid=@NewTenantId

-- lets add the new ones and create the associataions

insert into compliance..TCheckListCategory (CategoryName,IsSystemCategory,TenantId,IsArchived,ConcurrencyId)
select CategoryName,IsSystemCategory,@NewTenantId,IsArchived,ConcurrencyId from compliance..TCheckListCategory where tenantId=@SimplyBizNetworkAccountTenantId

insert into compliance..TCheckListQuestion (Category,Question,Description,TenantId,IsArchived,ConcurrencyId)
select Category,Question,Description,@NewTenantId,IsArchived,ConcurrencyId from compliance..TCheckListQuestion where tenantId=@SimplyBizNetworkAccountTenantId

-- lets cursor this puppy as we need to associate the questions with the category
DECLARE @CheckListCategoryId bigint, @CheckListQuestionId bigint,@OrdinalPosition int
DECLARE @CheckListCategoryNewId bigint, @CheckListQuestionNewId bigint

DECLARE checklistquestion_cursor CURSOR
FOR SELECT A.CheckListCategoryId, A.CheckListQuestionId,OrdinalPosition FROM compliance..TCheckListCategoryQuestion A
	Inner Join compliance..TCheckListQuestion B on a.CheckListQuestionId=B.CheckListQuestionId
	where B.tenantId=@SimplyBizNetworkAccountTenantId
	OPEN checklistquestion_cursor 

	FETCH NEXT FROM checklistquestion_cursor  Into @CheckListCategoryId, @CheckListQuestionId,@OrdinalPosition 

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- lets match the category and the question
		select @CheckListQuestionNewId = A.CheckListQuestionId  from compliance..TCheckListQuestion A
		Inner join compliance..TCheckListQuestion B on a.Question=B.Question
		where A.tenantId=@NEwTenantId and B.CheckListQuestionId=@CheckListQuestionId
		
		-- now the catrgory

		select @CheckListCategoryNewId=A.CheckListCategoryId from compliance..TCheckListCategory A
		Inner join compliance..TCheckListCategory B on a.CategoryName=B.CategoryName
		Where A.tenantId=@NEwTenantId and B.CheckListCategoryId=@CheckListCategoryId

		-- lets insert the puppy

		Insert into compliance..TCheckListCategoryQuestion(CheckListCategoryId,CheckListQuestionId,OrdinalPosition,ConcurrencyId)
		Values (@CheckListCategoryNewId, @CheckListQuestionNewId, @OrdinalPosition, 1)

		FETCH NEXT FROM checklistquestion_cursor  Into @CheckListCategoryId, @CheckListQuestionId,@OrdinalPosition 
    END
	
	
CLOSE checklistquestion_cursor 
DEALLOCATE checklistquestion_cursor

-- lets set up author
exec SpCustomCreateIndigoClientPreference '0',	@NewTenantId, @NewTenantGuid, 'AuthorContentProvider', 	'20360B65-8615-43CB-B387-46F181676C40', 0

-- add Dynamic Planner (SimplyBiz) 
declare @RefApplicationId int 
select @RefApplicationId = IsNull(RefApplicationId,0)        
from policymanagement..trefapplication          
where ApplicationName = 'Dynamic Planner (SimplyBiz)'          

IF NOT EXISTS (SELECT 1 FROM PolicyManagement..TApplicationLink WHERE RefApplicationId = @RefApplicationId AND IndigoClientId = @NewTenantId)
BEGIN      
	INSERT INTO PolicyManagement..TApplicationLink (IndigoClientId, RefApplicationId, MaxLicenceCount, CurrentLicenceCount, AllowAccess, ExtranetURL, ReferenceCode, ConcurrencyId, IntegratedSystemConfigRole)  
	VALUES (@NewTenantId, @RefApplicationId, null, null, 1, null, null, 1, 7) 
END
ELSE
BEGIN
	UPDATE PolicyManagement..TApplicationLink 
	SET AllowAccess = 1
	WHERE RefApplicationId = @RefApplicationId 
	AND IndigoClientId = @NewTenantId
END


GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Nio_atrcategory_custom_create] 
	 @AtrCategoryId  BIGINT = 0
	,@Name           VARCHAR(255)
	,@IsArchived     BIT
	,@TenantGuid	 UNIQUEIDENTIFIER
	,@TenantId       BIGINT
	,@ConcurrencyId  BIGINT
	,@Guid			 UNIQUEIDENTIFIER
AS
  --declare @AtrCategoryId bigint  
  DECLARE @StampUser VARCHAR(255)

  SELECT @StampUser = '999888777'

  BEGIN
  
      INSERT tatrcategory
             (guid,tenantid,tenantguid,name,isarchived,concurrencyid)
      SELECT  @Guid,@TenantId,@TenantGuid,@Name,@IsArchived,1

      SELECT @AtrCategoryId = SCOPE_IDENTITY()

      INSERT tatrcategorycombined
             (guid,atrcategoryid,tenantid,tenantguid,name,isarchived,concurrencyid)
      SELECT  @Guid,@AtrCategoryId,@TenantId,@TenantGuid,@Name,@IsArchived,1

      EXEC factfind..Spnauditatrcategorycombined
        @StampUser,
        @AtrCategoryId,
        'C'
  END

  SELECT @AtrCategoryId
GO

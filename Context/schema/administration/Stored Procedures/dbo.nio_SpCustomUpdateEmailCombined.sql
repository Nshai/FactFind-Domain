SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[nio_SpCustomUpdateEmailCombined]
@EmailGuid uniqueidentifier = NULL,
@UserGuid uniqueidentifier = NULL,
@OldEmailGuid uniqueidentifier = NULL
AS

if exists
(select 1 from Administration..TUserEmailConfigCombined where EmailGuid = @OldEmailGuid and UserGuid = @UserGuid)
begin

UPDATE [Administration].[dbo].[TUserEmailConfigCombined]
   SET [EmailGuid] = @EmailGuid,
       [UserGuid] =  @UserGuid,
       [ConcurrencyId] = [ConcurrencyId] + 1
 WHERE EmailGuid = @OldEmailGuid and UserGuid = @UserGuid

end
else
begin

INSERT INTO [Administration].[dbo].[TUserEmailConfigCombined]
           ([EmailGuid]
           ,[UserGuid]
           ,[ConcurrencyId])
       VALUES
           (@EmailGuid,
		    @UserGuid,
            1)
end
GO
